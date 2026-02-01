from datetime import datetime, timedelta

from train_service import (
    find_candidate_trains,
    is_train_valid_for_date,
    get_all_stations,
    seats_available,
    insert_booking,
    get_station_offset,
    get_user_bookings,
    get_route_order_map,
    get_connection,
    get_running_days,
    get_total_seats
)


def show_stations():
    stations = get_all_stations()
    print("\nAvailable Stations:")
    print("-------------------")
    for sid, name in stations:
        print(f"{sid:4d}  {name}")
    print("-------------------")


def book_ticket(user_id):
    show_stations()

    src = int(input("Enter SOURCE station ID: "))
    dst = int(input("Enter DESTINATION station ID: "))

    if src == dst:
        print("Source and destination cannot be same.")
        return

    date_str = input("Enter journey date (YYYY-MM-DD): ")
    journey_date = datetime.strptime(date_str, "%Y-%m-%d").date()

    trains = find_candidate_trains(src, dst)

    print("\nEligible trains:")
    valid_trains = []

    for train_id in trains:
        if is_train_valid_for_date(train_id, src, journey_date):
            print("Train ID:", train_id)
            valid_trains.append(train_id)

    if not valid_trains:
        print("No trains available for this route and date.")
        return

    train_id = int(input("\nEnter train ID to book: "))
    if train_id not in valid_trains:
        print("Invalid train selection.")
        return

    offset = get_station_offset(train_id, src)
    train_start_date = journey_date - timedelta(days=offset)

    available = seats_available(train_id, train_start_date, src, dst)

    print("Available seats in this segment:", available)

    if available > 0:
        choice = input("Confirm booking? (y/n): ")
        if choice.lower() == 'y':
            insert_booking(user_id, train_id, journey_date,
                           train_start_date, src, dst)
            print(" Booking successful!")
    else:
        print(" No seats available.")


def show_my_bookings(user_id):
    rows = get_user_bookings(user_id)

    if not rows:
        print("\nNo bookings found.")
        return

    print("\nMy Bookings:\n")

    header = (
        f"{'BID':<6}"
        f"{'TrainID':<9}"
        f"{'Train Name':<20}"
        f"{'Journey':<12}"
        f"{'Start':<12}"
        f"{'From':<15}"
        f"{'To':<15}"
    )
    print(header)
    print("-" * len(header))

    for bid, tid, tname, jdate, sdate, src, dst in rows:
        print(
            f"{bid:<6}"
            f"{tid:<9}"
            f"{tname:<20}"
            f"{str(jdate):<12}"
            f"{str(sdate):<12}"
            f"{src:<15}"
            f"{dst:<15}"
        )

    print("-" * len(header))

def safe_book_ticket(user_id, train_id, journey_date,
                     train_start_date, from_station_id, to_station_id):

    route_map = get_route_order_map(train_id)
    new_from = route_map[from_station_id]
    new_to = route_map[to_station_id]
    total_seats = get_total_seats(train_id)

    conn = get_connection()
    cur = conn.cursor()

    try:
        # ---- START TRANSACTION ----
        conn.start_transaction()

        # ---- LOCK ALL BOOKINGS OF THIS TRAIN RUN ----
        cur.execute("""
            SELECT booking_id, from_station_id, to_station_id
            FROM bookings
            WHERE train_id=%s AND train_start_date=%s
            FOR UPDATE
        """, (train_id, train_start_date))

        bookings = cur.fetchall()

        # ---- COUNT OVERLAPS WHILE LOCK HELD ----
        overlap = 0
        for _, f_sid, t_sid in bookings:
            f = route_map[f_sid]
            t = route_map[t_sid]
            if f < new_to and t > new_from:
                overlap += 1

        if overlap >= total_seats:
            conn.rollback()
            print(f"[User {user_id}]  No seats (blocked by lock)")
            return False

        # ---- INSERT BOOKING ----
        cur.execute("""
            INSERT INTO bookings
            (user_id, train_id, journey_date, train_start_date,
             from_station_id, to_station_id)
            VALUES (%s,%s,%s,%s,%s,%s)
        """, (user_id, train_id, journey_date, train_start_date,
              from_station_id, to_station_id))

        # ---- COMMIT (RELEASE LOCK) ----
        conn.commit()
        print(f"[User {user_id}]  Booking successful (safe)")
        return True

    except Exception as e:
        conn.rollback()
        print("Booking failed:", e)
        return False

    finally:
        cur.close()
        conn.close()



def main():
    print("\n==== Railway Reservation System ====\n")

    # -------- LOGIN --------
    user_id = int(input("Enter your USER ID to login: "))
    print("Login successful!\n")

    # -------- MENU LOOP --------
    while True:
        print("\nMenu:")
        print("1. Book Ticket")
        print("2. View My Bookings")
        print("3. Logout")

        choice = input("Enter choice: ")

        if choice == "1":
            book_ticket(user_id)

        elif choice == "2":
            show_my_bookings(user_id)

        elif choice == "3":
            print("Logging out...")
            break

        else:
            print("Invalid option.")


if __name__ == "__main__":
    main()
