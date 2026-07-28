# Recipe Explorer

A Flutter app to browse, search, and save recipes — with cuisine filtering, an analytics chart, and a Grocery Store Finder that helps you buy ingredients nearby.

Built with **GetX**, **Firebase Authentication (Google Sign-In)**, the **DummyJSON Recipes API**, **fl_chart**, and **flutter_map + OpenStreetMap**.

## Screenshots


<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/0b44d339-ba08-48f1-bc07-fd23be49f3d8" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/6143f74b-a000-4bcc-9fe5-4f77bfae5a83" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/03a167c6-af5a-4a97-9e87-6a1922b3bd7f" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/5341cd90-db8c-4784-8829-91ad39c95080" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/f0d66d80-9321-486b-8d46-9aef384bff34" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/2ec4639b-9110-484f-ab23-eb4d3ef5eaf5" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/8a260b0b-b090-40d3-be27-9d601bac2bcc" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/84040466-4f4c-47e4-97f0-4894db02d914" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/02796375-57cc-46d5-ab48-a89c6ddbfcd6" />
<img width="225" height="500" alt="Image" src="https://github.com/user-attachments/assets/fb1e7721-b230-4e57-8e58-0d86583c80e2" />

## Features

- Google Sign-In
- Browse, search, and filter recipes by cuisine (infinite scroll + pull-to-refresh)
- Analytics chart of recipes viewed per cuisine
- Recipe details with adjustable servings
- Wishlist (saved locally)
- Grocery Store Finder — pick a store on the map, get its address and distance
- Profile with logout

## Setup

1. Clone the repo and install dependencies:
   ```bash
   git clone https://github.com/shivani909/recipe_app.git
   cd recipe_explorer
   flutter pub get
   ```

2. Set up Firebase for Google Sign-In:
   - Create a project in the [Firebase Console](https://console.firebase.google.com/)
   - Enable Google as a sign-in provider
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`

3. Run the app:
   ```bash
   flutter run
   ```

No API keys needed for recipes or maps — DummyJSON and Nominatim are both free.

## Tech Stack

- Flutter + GetX (state management, DI, routing)
- Firebase Authentication
- DummyJSON Recipes API
- fl_chart
- flutter_map + OpenStreetMap + Nominatim (reverse geocoding)
- GetStorage (local persistence)

## Notes

- Wishlist and profile picture are stored locally on the device only.
- Distance to the grocery store is a straight-line distance, not a routed one.
