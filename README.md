# Railway Ticket Booking System

A Python-based railway ticket booking system that enables users to search for trains, check seat availability, and book tickets.

## Features

- 🚂 Search and find trains between stations
- 🎫 Book train tickets with real-time seat availability
- 👤 View your booking history
- 📅 Check trains by date and availability
- 🗺️ Support for multi-stop train routes

## Project Structure

```
railway_app/
├── main.py              # Main application interface
├── db.py                # Database connection
├── train_service.py     # Business logic
├── railway_db.sql       # Database schema
└── README.md            # Documentation
```

## Prerequisites

- Python 3.7+
- MySQL Server
- MySQL Connector for Python

## Installation

1. **Install dependencies:**

```bash
pip install mysql-connector-python
```

2. **Setup database:**

```bash
mysql -u root -p < railway_db.sql
```

3. **Update credentials in `db.py`:**

```python
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="6116",
        database="railway_db"
    )
```

## Usage

Run the application:

```bash
python main.py
```

### Steps to Book a Ticket:

1. Enter your User ID
2. Choose source and destination stations
3. Select journey date (YYYY-MM-DD format)
4. Pick a train from available options
5. Confirm booking

### View Your Bookings:

Enter your User ID to see all your past bookings with details like train name, date, and stations.

## Database Tables

- `stations` - Railway stations
- `trains` - Train information
- `train_routes` - Train stops and order
- `train_station_schedules` - Station timing
- `train_running_days` - Operating days
- `bookings` - User reservations

## Troubleshooting

**MySQL connection error?**

- Check credentials in `db.py`
- Ensure MySQL is running
- Verify database exists

**No trains found?**

- Confirm stations are in the system
- Check if train operates on that day
- Use correct date format

**No seats available?**

- Check train capacity
- Verify existing bookings
- Try different dates/trains

## Main Functions

- `book_ticket(user_id)` - Book a new ticket
- `show_my_bookings(user_id)` - View your bookings
- `show_stations()` - List all stations
- `find_candidate_trains(src, dst)` - Search trains
- `seats_available(train_id, date, src, dst)` - Check availability

## Future Improvements

- User authentication
- Ticket cancellation
- Payment integration
- Web interface
- Email confirmations

---

Built with Python and MySQL | v1.0 | February 2026
