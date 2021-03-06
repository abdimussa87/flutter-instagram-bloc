import 'package:flutter/material.dart';
import 'package:instagram_bloc/screens/edit_profile/edit_profile_screen.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  const ProfileButton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? FlatButton(
            onPressed: () => Navigator.of(context).pushNamed(
              EditProfileScreen.routeName,
              arguments: EditProfileScreenArgs(
                context: context,
              ),
            ),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16),
            ),
          )
        : FlatButton(
            onPressed: () {},
            textColor: isFollowing ? Colors.black : Colors.white,
            color:
                isFollowing ? Colors.grey[300] : Theme.of(context).primaryColor,
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(fontSize: 16),
            ),
          );
  }
}
