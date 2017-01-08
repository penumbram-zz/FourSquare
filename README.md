### Version 0.1 ###

* Foursquare authentication

*  UICollectionView implementation

### Version 1.0 ###

* Foursquare authentication

* Gets latitude and longitude values from the keyboard and searches trending places for the current date, pushes a UIViewController with a UICollectionView in it, with subclassed cells (FSCVCell), using UINavigationController set in UIAppDelegate.

* Displays the trending places in a UICollectionView with reusable cells.(1/5 api requests)

* If the user taps on one of the cells, Detailed information about the place pops in a UIView with more options

* Those options include: 

- Like (2/5 api requests)
- Dislike (2/5 api requests) (Did not  want to count Like and Dislike as two different requests, but both are done in the same function using a parameter)
- See place Images (in a UIImageView) (3/5 api requests)
- See similar places in the UICollectionView (4/5 api requests)
- See next places in the UICollectionView (A foursquare feature i learned about during the development phase, a list of related places to the selected one ) (5/5 api requests)

Main View:
![iOS Simulator Screen shot 07 Jun 2014 19.44.29.png](https://github.com/penumbram/FourSquare/blob/master/screenshots/3473504430-iOS%20Simulator%20Screen%20shot%2007%20Jun%202014%2019.44.29.png)

The UICollectionView after authentication and first response:
![iOS Simulator Screen shot 07 Jun 2014 19.45.53.png](https://github.com/penumbram/FourSquare/blob/master/screenshots/3801621180-iOS%20Simulator%20Screen%20shot%2007%20Jun%202014%2019.45.53.png)

UICollectionView Click on a Cell, a new view shows up with options: (Notice the background dimmed and non-responsive to touch)
![iOS Simulator Screen shot 07 Jun 2014 19.46.54.png](https://github.com/penumbram/FourSquare/blob/master/screenshots/4016062463-iOS%20Simulator%20Screen%20shot%2007%20Jun%202014%2019.46.54.png)

UIImageView with venue photos from saved urls of foursquare. (Using AFNetworking HTTPRequest with a serialiser)
If all photos are shown, returns to the beginning (does not crash as far as i am concerned), Can be closed with the button at the top right.
![iOS Simulator Screen shot 07 Jun 2014 19.48.57.png](https://github.com/penumbram/FourSquare/blob/master/screenshots/2303497925-iOS%20Simulator%20Screen%20shot%2007%20Jun%202014%2019.48.57.png)
