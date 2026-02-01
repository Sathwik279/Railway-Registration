from db import get_connection
from datetime import datetime,timedelta

# all these are util methods
def get_station_offset(train_id, station_id):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT day_offset
        FROM train_station_schedules
        WHERE train_id=%s AND station_id=%s
    """, (train_id, station_id))

    offset = cur.fetchone()[0]
    cur.close()
    conn.close()
    return offset

def get_running_days(train_id):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        select day_of_week from train_running_days
        where train_id=%s""",(train_id,)
    )

    days = {row[0]for row in cur.fetchall()} # this is a set again taking 0th index for each tuple

    cur.close()
    conn.close()

    return days

def get_all_stations():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("select station_id,station_name from stations order by station_id")
    stations = cur.fetchall()
    

    cur.close()
    conn.close()
    return stations

def get_total_seats(train_id):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT total_seats FROM trains WHERE train_id=%s", (train_id,))
    seats = cur.fetchone()[0]

    cur.close()
    conn.close()
    return seats

def get_route_order_map(train_id):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT station_id, stop_order
        FROM train_routes
        WHERE train_id = %s
    """, (train_id,))

    route = {station: order for station, order in cur.fetchall()}

    cur.close()
    conn.close()
    return route


# these are the functional methods
def find_candidate_trains(src_station_id,dst_station_id):
    conn = get_connection()
    cur = conn.cursor()

    query = """
    select r1.train_id from train_routes r1
    join train_routes r2 on r1.train_id = r2.train_id
    where r1.station_id = %s and r2.station_id = %s
    and r1.stop_order < r2.stop_order
    """

    cur.execute(query,(src_station_id,dst_station_id))
    trains = [row[0] for row in cur.fetchall()] # this is an array  as each row is a tuple we are taking the 0th index from each tuple

    cur.close()
    conn.close()
    return trains

def is_train_valid_for_date(train_id,src_station_id,journey_date):
    offset = get_station_offset(train_id,src_station_id)
    print(offset)

    train_start_date = journey_date-timedelta(days = offset)
    weekday = train_start_date.isoweekday() # we get day
    print(weekday,train_start_date)
    running_days = get_running_days(train_id)
    return weekday in running_days

def seats_available(train_id, train_start_date, from_station_id, to_station_id):
    route_map = get_route_order_map(train_id)

    new_from = route_map[from_station_id] # these denote the order or index of the station of source of the user
    new_to   = route_map[to_station_id]

    total_seats = get_total_seats(train_id)

    conn = get_connection()
    cur = conn.cursor()

    # we use the train_start_date to find the instance of train the current user wants to board
    cur.execute("""
        SELECT from_station_id, to_station_id
        FROM bookings
        WHERE train_id=%s AND train_start_date=%s
    """, (train_id, train_start_date))

    bookings = cur.fetchall()
    cur.close()
    conn.close()

    overlap = 0
    for f_sid, t_sid in bookings: # we are iterating over the whole bookings for our train instance and finding the number of bookings of our instance which overlpa our segment
        f = route_map[f_sid]
        t = route_map[t_sid]
        if f < new_to and t > new_from:
            overlap += 1

    available = total_seats - overlap
    return available

def insert_booking(user_id, train_id, journey_date, train_start_date,
                   from_station_id, to_station_id):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO bookings
        (user_id, train_id, journey_date, train_start_date,
         from_station_id, to_station_id)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (user_id, train_id, journey_date, train_start_date,
          from_station_id, to_station_id))

    conn.commit()
    cur.close()
    conn.close()

def get_user_bookings(user_id):
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT b.booking_id, b.train_id, t.train_name,
               b.journey_date,b.train_start_date, s1.station_name, s2.station_name
        FROM bookings b
        JOIN trains t ON b.train_id = t.train_id
        JOIN stations s1 ON b.from_station_id = s1.station_id
        JOIN stations s2 ON b.to_station_id = s2.station_id
        WHERE b.user_id = %s
        ORDER BY b.booking_time DESC
    """, (user_id,))

    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows




# def count_overlapping_bookings(train_id, journey_date, new_from, new_to):
#     conn = get_connection()
#     cur = conn.cursor()

#     cur.execute("""
#         SELECT from_station_id, to_station_id
#         FROM bookings
#         WHERE train_id=%s AND train_start_date=%s
#     """, (train_id, journey_date))

#     bookings = cur.fetchall()

#     cur.close()
#     conn.close()

#     overlap = 0
#     for f, t in bookings:
#         if f < new_to and t > new_from:
#             overlap += 1

#     return overlap