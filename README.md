# SaliencyPhotoBrowser
 
## Architecture and design
 
This app uses the PhotoKit framework to display the user’s most recent 1000 photos in a grid. Then you can see each image on full screen, zoom in. Also I've used the Vision framework to analyse attention-based saliency for the image and draw a red rectangle around the salient portion of the image.
 
This is a SwiftUI project so it uses MVVM architecture. It’s natural to use MVVM for SwiftUI. It comes with Actor ViewModels that are thread safe and work best with SwiftUI views.
 
## Code highlights
 
PhotoViewerView page has a zoom button that switches image size between Fit and Fill modes. I could use .scaledToFit and .scaledToFill image view modifiers, but then I could not get animation on switching between those two modes. So, instead I implemented custom zooming, by manually calculating appropriate image size and setting it to the image frame inside the ScrollView. Calculations are done inside PhotoViewerViewModel and UnitTesed in PhotoViewerViewModelTests.
 
## What would I improve if I had more time
 
I would add more UnitTests and UI tests if I had more time.
 
I would fix the status bar text on the PhotoViewerView page. Right now it is black on black and it is not very clear how to change it for one single page in SwiftUI.
 
## What would I would do differently
 
I follow closely the design provided with the assessment, but if I had more freedom the I would:
 
1. Expand image from the same page, so clicked image would grow and fill the whole screen 
2. I would use two zoom buttons that would represent the zoom state. I would show magnifying glass with plus button when you in fit mode and show magnifying glass with minus button when you in fill mode
3. I would enable the saliency box only upon user request, not showing it all the time.

