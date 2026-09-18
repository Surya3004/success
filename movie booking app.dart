import 'dart:io';

class Movieticketbooking {
  final String username = "surya";
  final String password = "Sury@3004";

  int attempts = 3;

  Map<String, int> movies = {
    "Mankatha!": 180,
    "Dragon": 150,
    "Retro": 130,
    "Tourist": 110,
  };

  List<String> timings = [
    "1. 10:00 AM",
    "2. 1:30 PM",
    "3. 6:30 PM",
    "4. 9:30 PM",
  ];


  Map<String, Map<int, Map<String, String>>> showSeats = {};

  String? bookedMovie;
  int? bookedShow;
  List<String> bookedSeats = [];
  int bookedQuantity = 0;
  int bookedTotal = 0;

  Movieticketbooking() {
    for (String movie in movies.keys) {
      showSeats[movie] = {};

      for (int show = 0; show < timings.length; show++) {
        showSeats[movie]![show] = {
          "A1": "available",
          "A2": "available",
          "A3": "available",
          "A4": "available",
          "A5": "available",
          "A6": "available",
          "B1": "available",
          "B2": "available",
          "B3": "available",
          "B4": "available",
          "B5": "available",
          "B6": "available",
        };
      }
    }
  }
}

class Login extends Movieticketbooking {
  Future<void> login() async {
    print("=======================================");
    print("        MOVIE TICKET BOOKING");
    print("=======================================");
    print("1.Login   2.Exit");
    print("Enter choice:");

    String? choiceInput = stdin.readLineSync();
    int choice = int.tryParse(choiceInput ?? "") ?? 0;

    while (true) {
      if (choice == 1) {
        print("Enter username:");
        String enteringUsername = stdin.readLineSync() ?? "";

        if (username == enteringUsername) {
          attempts = 3;

          while (attempts > 0) {
            print("Enter password:");
            String enteringPassword = stdin.readLineSync() ?? "";

            if (password == enteringPassword) {
              print("Login success!");
              return;
            } else {
              attempts--;
              print("Wrong password!");
              print("Attempts left: $attempts");
            }

            if (attempts == 0) {
              print("Maximum attempts reached.");
              exit(0);
            }
          }
        } else {
          print("Invalid user id!");
        }
      } else if (choice == 2) {
        print("Exiting.....");
        await Future.delayed(const Duration(seconds: 2));
        print("============== EXIT ==============");
        exit(0);
      } else {
        print("Invalid choice!");
      }

      print("\n1.Login   2.Exit");
      print("Enter choice:");

      String? nextChoice = stdin.readLineSync();
      choice = int.tryParse(nextChoice ?? "") ?? 0;
    }
  }
}

class Mainmenu extends Login {
  void menu() {
    while (true) {
      print("\n=================== MAIN MENU =================");
      print("1. Show Movies");
      print("2. Book Ticket");
      print("3. View Booking");
      print("4. Cancel Booking");
      print("5. Exit");

      print("Enter option:");
      String? optionInput = stdin.readLineSync();
      int option = int.tryParse(optionInput ?? "") ?? 0;

      switch (option) {
        case 1:
          showMovies();
          break;

        case 2:
          bookTicket();
          break;

        case 3:
          viewBooking();
          break;

        case 4:
          cancelBooking();
          break;

        case 5:
          print("Exiting.....");
          return;

        default:
          print("Invalid option!");
      }
    }
  }

  void showMovies() {
    print("\n----------- NOW SHOWING -----------");

    int index = 1;
    for (var entry in movies.entries) {
      print("$index. ${entry.key} - Rs.${entry.value}");
      index++;
    }
  }

  void bookTicket() {
    print("\n----------- BOOK TICKET -----------");

    List<String> movieNames = movies.keys.toList();

    for (int i = 0; i < movieNames.length; i++) {
      print("${i + 1}. ${movieNames[i]} - Rs.${movies[movieNames[i]]}");
    }

    print("Select movie:");
    int selectMovie = readInt();

    if (selectMovie < 1 || selectMovie > movieNames.length) {
      print("Invalid movie selection!");
      return;
    }

    String selectedMovie = movieNames[selectMovie - 1];
    print("You selected $selectedMovie");

    print("\n---------- SHOW TIMES ----------");


    for (String timing in timings) {
      print(timing);
    }

    print("Select show:");
    int selectShow = readInt();

    if (selectShow < 1 || selectShow > timings.length) {
      print("Invalid show selection!");
      return;
    }

    int showIndex = selectShow - 1;
    Map<String, String> seatsForShow = showSeats[selectedMovie]![showIndex]!;

    print("\nMovie: $selectedMovie");
    print("Show: ${timings[showIndex]}");

    print("\n---------- SEATS ----------");
    for (var entry in seatsForShow.entries) {
      print("${entry.key}: ${entry.value}");
    }

    print("How many seats:");
    int quantity = readInt();


    if (quantity <= 0) {
      print("Invalid quantity! Please enter at least 1 ticket.");
      return;
    }

    int availableSeats =
        seatsForShow.values.where((status) => status == "available").length;


    if (quantity > availableSeats) {
      print("Only $availableSeats seats are available.");
      return;
    }

    List<String> selectedSeats = [];
    int i = 1;

    while (i <= quantity) {
      print("Enter seat number for ticket $i:");
      String seatNumber = (stdin.readLineSync() ?? "").trim().toUpperCase();

      if (!seatsForShow.containsKey(seatNumber)) {
        print("Invalid seat number!");
        continue;
      }

      if (seatsForShow[seatNumber] == "available") {
        seatsForShow[seatNumber] = "booked";
        selectedSeats.add(seatNumber);
        i++;

        print("$seatNumber seat is booked!");
      } else if (seatsForShow[seatNumber] == "booked") {
        print("Seat already booked. Choose another seat.");
      } else {
        print("Invalid seat status!");
      }
    }

    int price = movies[selectedMovie]!;
    int total = price * quantity;

    bookedMovie = selectedMovie;
    bookedShow = showIndex;
    bookedSeats = selectedSeats;
    bookedQuantity = quantity;
    bookedTotal = total;

    print("\n========== BOOKING CONFIRMED ==========");
    print("Movie: $bookedMovie");
    print("Show: ${timings[bookedShow!]}");
    print("Seats: ${bookedSeats.join(", ")}");
    print("Tickets: $bookedQuantity");
    print("Price per ticket: Rs.$price");
    print("Total amount: Rs.$bookedTotal");
    print("=======================================");
  }

  void viewBooking() {
    print("\n----------- VIEW BOOKING -----------");

    if (bookedMovie == null) {
      print("No booking found.");
      return;
    }

    print("Movie: $bookedMovie");
    print("Show: ${timings[bookedShow!]}");
    print("Seats: ${bookedSeats.join(", ")}");
    print("Tickets: $bookedQuantity");
    print("Total amount: Rs.$bookedTotal");
  }

  void cancelBooking() {
    print("\n----------- CANCEL BOOKING -----------");

    if (bookedMovie == null) {
      print("No booking found.");
      return;
    }

    Map<String, String> seatsForShow =
    showSeats[bookedMovie]![bookedShow!]!;

    for (String seat in bookedSeats) {
      seatsForShow[seat] = "available";
    }

    print("Booking cancelled successfully.");
    print("Movie: $bookedMovie");
    print("Seats: ${bookedSeats.join(", ")}");

    bookedMovie = null;
    bookedShow = null;
    bookedSeats = [];
    bookedQuantity = 0;
    bookedTotal = 0;
  }

  int readInt() {
    while (true) {
      String input = stdin.readLineSync() ?? "";
      int? value = int.tryParse(input);

      if (value != null) {
        return value;
      }

      print("Invalid input! Please enter a number:");
    }
  }
}

Future<void> main() async {
  Mainmenu obj = Mainmenu();

  await obj.login();
  obj.menu();
}