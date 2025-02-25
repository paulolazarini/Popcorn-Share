<h1>
  Popcorn Share - SwiftUI
  <span>&nbsp;&nbsp;</span>
  <a href="https://developer.apple.com/swift/" target="_blank" rel="noreferrer">
    <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/swift/swift-original.svg" 
         alt="Swift" width="40" height="40"/>
  </a>
</h1>

## Project Overview

This project combines **SwiftUI** for building views, **UIKit** for navigation and **Swift Package Manager** to modularize the application.   
It follows the **MVVM-C (Model-View-ViewModel-Coordinator)** architecture and uses **Firebase** as the backend,  
including **Firebase Authentication** for user authentication and account management.

### Goals

- **Share movies** with others and create **collaborative playlists**.  
- **Discover new movies** based on community recommendations.  
- **Search for detailed movie information**.  
- **Add movies to a favorites list** and write **personal reviews**.  

By blending SwiftUI's modern UI capabilities with UIKit's robust navigation,  
this app delivers a seamless and engaging experience for movie enthusiasts.

## Evidence

https://github.com/user-attachments/assets/b2fbc33e-850d-473c-b483-4d1568110ea5

## How to run on your machine

- Xcode: Install Xcode IDE to run the project.
- Firebase: Create a Firebase project and set up Firebase Authentication and Database.
- TMDB API Read Access Token: Get the key from TMDB by following this tutorial: [TMDB: Getting Started](https://developer.themoviedb.org/docs/getting-started).

1. Clone the repository

```sh
git clone https://github.com/paulolazarini/Popcorn-Share
```
2. Configure project

- Add the .plist from Firebase to the project, making sure it is configured.
- Get the TMDB API and paste it on MOVIE_API_KEY field, in the info.plist. 

3. Build and run the application.


