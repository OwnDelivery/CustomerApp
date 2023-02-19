# Own Delivery

Own Delivery Customer App for food delivery.

## Setup

- Create a firebase web app with realtime database and hosting enabled
- Create a new file `env` using the template `env.example` with the values for the firebase app
- To run local firebase emulators `firebase emulators:start`
- Run the command `flutter run` to run this application locally.

- Run `flutter pub run build_runner build`
- Run `flutter run --web-renderer html --web-browser-flag "--disable-web-security"`

## To buiild debug build

- Run `flutter build web --profile --dart-define=Dart2jsOptimization=O0`

## To run locally

-

Run `flutter run --web-renderer html -d web-server --web-port 8080 --web-hostname 0.0.0.0 --web-browser-flag "--disable-web-security"`

## For html render(Faster loading)

- Run `flutter build web --profile --dart-define=Dart2jsOptimization=O0 --web-renderer html`

## To deploy it to Firebase for release

- Run `flutter build web release` Mapbox and url_launcher not working and flutter loading is slow.
  So
- Run `flutter build web --profile --dart-define=Dart2jsOptimization=O0 --web-renderer html`
- Run `firebase hosting:channel:deploy beta` For beta
- Run `firebase deploy --only hosting` to deploy the application

For Live Demo: https://tw-planning-poker.web.app/

## Server side

Right now this app uses firebase realtime database as the primary source as backend. We have server
side validation added in `database.rules.json`
