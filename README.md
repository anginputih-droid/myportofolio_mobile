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

- **Tutorial 09:** added the drawer (Home and Add Project), the Add Project form with validation and a dialog, and moved the files into `screens/` and `widgets/`.
- **Assignment 8:** added an Add Experience form (title, description, category, thumbnail URL, start and end date) with validation, an Add Experience button on the home page and in the drawer, and a dialog that shows what was entered. Also fixed overflow on narrow screens (info cards, menu buttons, drawer header, dropdowns).

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


### Assignment 8

**1. Explain the differences between `Navigator.push()`, `Navigator.pushReplacement()`, and `Navigator.pop()`. Which method opens the form from the action card? Explain how the Home option in the drawer takes the user back to the home screen.**
Flutter keeps pages in a stack. `push()` puts a new page on top, and the old page stays underneath, so the back button still works. `pushReplacement()` swaps the current page for a new one, so you can't go back to the page that was replaced. `pop()` removes the top page (or a dialog) and shows whatever is under it. The Add Experience card on the home page uses `push()`, so pressing back on the form returns to the home page. The Home option in the drawer uses `pushReplacement()` with `MyHomePage`, so the form gets replaced by the home page. I also use `pop()` in the OK button of the dialog to close it and go back to the form.

**2. How does the arrangement of `Scaffold`, `AppBar`, and `Drawer` keep the page structure consistent? Give one example of the portfolio theme colors being used on more than one page.**
Every page in my app is a `Scaffold` with an `AppBar` at the top, the content in the body, and the same `LeftDrawer` on the side. Because the drawer is its own widget in `widgets/left_drawer.dart`, the home page, the project form and the experience form all show the exact same menu. So every page has the same layout and the user always knows where the title and the menu are. For the colors, the theme in `main.dart` uses indigo as the seed color. The AppBar on the home page and on the Add Experience form both use `Theme.of(context).colorScheme.primary`, so they get the same indigo. The drawer header and the Save button are indigo too.

**3. Why was this layout chosen for the form? Explain what the spacing and scrolling widgets do when screen space is limited.**
I put one field per row in a `Column`, so the form reads from top to bottom and still works on a narrow phone. Each field has a label, and some have a hint, so it's clear what to type. Every field is wrapped in `Padding` so there's space between them and they don't stick together. The whole form is inside a `SingleChildScrollView`, so when the screen is short or the keyboard covers part of it, the form scrolls instead of overflowing, and the Save button can always be reached. For the category I added `isExpanded: true` to the dropdown, because on a narrow screen the long option text was overflowing to the right.

**4. What roles do `GlobalKey<FormState>`, `validator`, and `validate()` play when Save is pressed? Give one example of a value the form rejects and explain why choosing an input widget or keyboard type alone is insufficient.**
The `GlobalKey<FormState>` is connected to the `Form`, so the Save button can reach the form's state. Each field has a `validator` that returns an error message if the input is wrong, or `null` if it's fine. When Save is pressed, `_formKey.currentState!.validate()` runs all the validators at once. If any of them returns a message, it shows in red under that field and the dialog doesn't open. Only when all of them return `null` does the dialog show up. One example is the thumbnail field: if I type `hello`, it's rejected because it isn't a link starting with `http://` or `https://`. The field uses `TextInputType.url`, but that only changes which keyboard shows up on a phone. You can still type or paste anything, so the validator is what actually checks it. Another example is a title with only spaces. It isn't empty, so only the `trim()` in the validator catches it.

**AI Usage Disclosure:** I used Claude only to ask theory questions.

- **Prompt Strategy:** While doing the tutorial and assignment, I asked Claude about concepts I was confused about, like how Navigator.push and pushReplacement differ, what GlobalKey<FormState> does, why validators return null. I didn't ask it to write my code. I used the answers to understand the material, then wrote the code and the README answers myself.
- **Limitations & Manual Fixes:** The answers were general and not about my project, so I had to apply them to my own code myself. I tested everything in Chrome and ran flutter analyze myself, since the AI couldn't run my app.
- **AI Chat Log:** https://claude.ai/share/c25fb73a-915c-486b-ad9f-f4e5255e4dfb