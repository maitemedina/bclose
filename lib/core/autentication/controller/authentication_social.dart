import 'dart:io';
// import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class AuthenticationSocial {

  //static final FacebookLogin facebookSignIn = new FacebookLogin();

  // GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  //   scopes: <String>[
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );

  Future facebookLogin() async {
    // final FacebookLoginResult result =
    // await facebookSignIn.logIn(['email']);
    //
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //     final FacebookAccessToken accessToken = result.accessToken;
    //     // _showMessage('''
    //     //  Logged in!
    //     //
    //     //  Token: ${accessToken.token}
    //     //  User id: ${accessToken.userId}
    //     //  Expires: ${accessToken.expires}
    //     //  Permissions: ${accessToken.permissions}
    //     //  Declined permissions: ${accessToken.declinedPermissions}
    //     //  ''');
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     // _showMessage('Login cancelled by the user.');
    //     break;
    //   case FacebookLoginStatus.error:
    //     // _showMessage('Something went wrong with the login process.\n'
    //     //     'Here\'s the error Facebook gave us: ${result.errorMessage}');
    //     break;
    // }
  }



  Future<Null> facebookLogOut() async {
    // await facebookSignIn.logOut();
    // _showMessage('Logged out.');
  }

  Future<Null> appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:
        'pt.bclose.bhealth',
        redirectUri: Uri.parse(
          'https://bhealth-bclose.firebaseapp.com/__/auth/handler',
        ),
      ),
      // TODO: Remove these if you have no need for them

      nonce: 'example-nonce',
      state: 'example-state',
    );

    print(credential);

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'flutter-sign-in-with-apple-example.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        if (credential.givenName != null)
          'firstName': credential.givenName!,
        if (credential.familyName != null)
          'lastName': credential.familyName!,
        'useBundleId':
        Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
        if (credential.state != null) 'state': credential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );

  }


  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data = json.decode(response.body);
  //   final String? namedContact = _pickFirstNamedContact(data);
  //
  // }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'];
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> loginGoogle() async {
    // try {
    //   await _googleSignIn.signIn();
    // } catch (error) {
    //   print(error);
    // }
  }

  // Future<void> _handleSignOut() => _googleSignIn.disconnect();

}