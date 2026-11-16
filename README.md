# MyPortfolio Mobile

This is the Flutter version of my personal portfolio for the PBP course. The web version is my Django project [myportofolio](https://github.com/anginputih-droid/myportofolio), and this app will connect to its API in the next tutorials. For now it has a home page with my info (NPM, name, class) and menu buttons for my portfolio sections.

Made by Angin Putih Ranulaksmi Tsurayya Hapsoro (2506557936), PBP KKI.

## How to run

You need the Flutter SDK installed (check with `flutter doctor`).

```
git clone https://github.com/anginputih-droid/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter run -d chrome
```

To check the code, run `flutter analyze`.

## Weekly progress

- **Tutorial 08:** set up Flutter, split `menu.dart` from `main.dart`, changed `MyHomePage` to a StatelessWidget, made `InfoCard` and `ItemCard`.
- **Assignment 7:** put my own data in the info cards, changed the buttons to match my portfolio (View Projects, View Experience, Add Project, Logout), gave each button its own color, and made the home page scrollable because the cards overflowed on a wide screen.

### Assignment 7

**1. Explain what a widget tree is in Flutter and how parent-child relationships work between widgets.**
In Flutter the whole UI is made of widgets, and they're nested inside each other, so together they form a tree. The parent widget decides where and how big its children can be, and the child just draws itself inside that space. For example in my app `Scaffold` is the parent of the `AppBar` and the body, the body has a `Column`, and the `Column` has the `Row` of info cards and the `GridView` as its children. If I change a parent (like adding `Padding`), everything inside it is affected too.

**2. List all the widgets you used in this project and explain each of their functions.**
- `MaterialApp`: the root of the app, sets the title and theme (colors).
- `Scaffold`: the basic page layout with an app bar and a body.
- `AppBar`: the bar at the top with the "MyPortfolio" title.
- `Text`: shows text.
- `SingleChildScrollView`: makes the page scrollable so it doesn't overflow.
- `Padding`: adds space around a widget.
- `Column` and `Row`: put widgets vertically and horizontally.
- `Center`: puts a widget in the middle.
- `SizedBox`: empty space between widgets.
- `Card`: a box with a shadow, used for the info cards.
- `Container`: a box where I can set width and padding.
- `GridView.count`: shows the menu buttons in a grid with 3 columns.
- `Material`: gives the button its background color and rounded corners.
- `InkWell`: makes the card tappable and shows the ripple effect.
- `Icon`: shows the icon on each button.
- `ScaffoldMessenger` and `SnackBar`: show the small message at the bottom when a button is tapped.
- `InfoCard` and `ItemCard`: my own widgets, one for the NPM/name/class cards and one for the menu buttons.

**3. What is the purpose of the `MaterialApp` widget? Explain why this widget is commonly used as the root widget in Flutter applications.**
`MaterialApp` sets up the things the whole app needs, like the theme, the app title, and navigation between pages. It also gives Material Design styling to the widgets inside it. It's usually the root because many widgets (like `Scaffold`, `AppBar` and `SnackBar`) need things that `MaterialApp` provides, like the theme and the navigator. In my app I set the theme there with `ColorScheme.fromSeed`, so every page can use the same colors with `Theme.of(context)`.

**4. Explain the difference between `StatelessWidget` and `StatefulWidget`. When should you choose StatelessWidget, and when is StatefulWidget necessary?**
A `StatelessWidget` can't change after it's built. It just shows what it's given. A `StatefulWidget` has a `State` object that can store data that changes, and calling `setState()` rebuilds it with the new data. My home page only shows fixed info and buttons, so StatelessWidget is enough. The default counter app needed StatefulWidget because the number changes every time you press the button. I'd use StatefulWidget for things like forms, counters, or data loaded from an API.

**5. What is `BuildContext` and why is it crucial in Flutter? How is it used inside the build method?**
`BuildContext` tells a widget where it is in the widget tree. With it, the widget can look up things from its parents. In my code I use `Theme.of(context)` to get the app colors, `MediaQuery.of(context)` to get the screen width for the info cards, and `ScaffoldMessenger.of(context)` to show the SnackBar. Without the context the widget wouldn't know which theme or which Scaffold it belongs to.

**6. Explain the concept of hot reload in Flutter and how it differs from hot restart. When can you not rely on hot reload and must instead perform a hot restart or full restart?**
Hot reload (`r`) puts the code changes into the app that's already running, and it keeps the current state, so it's really fast for UI changes like colors or text. Hot restart (`R`) restarts the app from the beginning, so the state is reset, but it's still quicker than stopping and running again. Hot reload isn't enough when I change things that only run once at the start, like `main()` or the initial value of a state, or when I change a class structure (for example turning a StatefulWidget into a StatelessWidget). Adding new packages in `pubspec.yaml` or changing native files needs a full restart (stop and `flutter run` again).

**AI Usage Disclosure:** I used Claude to help me with this assignment.

- **Prompt Strategy:** : I asked Claude theory questions while working on the tutorial, like the difference between StatelessWidget and StatefulWidget, what BuildContext is, why MaterialApp is the root widget, hot reload vs hot restart, why my page showed overflow stripes, and what the `..` cascade in the SnackBar code means. I used the answers to understand the code and wrote my README answers in my own words. I also got some step-by-step guidance on the Assignment 7 changes and a few terminal/git errors, but I typed and committed all the code myself.
- **Limitations & Manual Fixes:** The answers were general, so I had to connect them to my own code myself (for example, where Theme.of(context) and `MediaQuery.of(context)` are used in `menu.dart`). I chose my own button colors and tested everything in Chrome and with `flutter analyze` myself, since the AI couldn’t run my app.
- **AI Chat Log:** https://claude.ai/share/c1a956ba-4c63-404d-a2f5-6f35b0b7f6f1