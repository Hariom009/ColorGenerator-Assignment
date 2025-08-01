# ColorCode Project

Welcome to the ColorCode project! This README.md file will help you understand what this project does and how to get it up and running on your Apple device. Don't worry if you're new to this; we'll go through everything step-by-step!

## What is ColorCode?

ColorCode is a simple application built using Swift and SwiftUI (with some UIKit elements) that does a cool thing: it generates random colors! For each color, it also gives you its unique hexadecimal code (like #RRGGBB). But that's not all!

This project is designed to be smart about how it saves your generated colors:

- **Local Storage**: Every color you generate is immediately saved right on your device, so you don't lose it even if you're offline.
- **Cloud Sync (Firebase)**: When your device is connected to the internet, ColorCode automatically sends your new colors to a special online database called Firebase. This means your colors are safely stored in the cloud and can be accessed from different places (though this project focuses on a single user for now).
- **Smart Syncing**: If you generate a new color while online, it gets sent to Firebase right away! If you're offline and then come back online, ColorCode will check for any colors saved locally that haven't been synced yet and send them to Firebase.
- **Network Monitoring**: The app constantly checks if you're connected to the internet, so it knows when to sync the data.

## Features

- **Random Color Generation**: Get a new random color and its hex code with a tap.
- **Local Data Storage**: All generated colors (with a unique ID, hex code, and timestamp) are saved directly on your device using UserDefaults.
- **Firebase Integration**: Seamlessly syncs your color data with a Firebase Firestore database.
- **Offline-First**: Works perfectly even without an internet connection, saving data locally.
- **Automatic Cloud Sync**: Automatically uploads new and unsynced local data to Firebase when an internet connection is detected.
- **Real-time Online Sync**: Instantly syncs newly generated colors to Firebase when online.
- **Network Status Detection**: Actively monitors your internet connection status.

## Prerequisites

Before you can run this project, you'll need a few tools installed on your computer. Think of these as the basic ingredients for our recipe!

### Git

This is a tool used to download (or "clone") the project's code from the internet.

- **How to check if you have it**: Open your computer's terminal or command prompt and type `git --version`. If you see a version number, you're good!
- **How to get it**: If not, download and install it from [git-scm.com](https://git-scm.com).

### Xcode

This is Apple's integrated development environment (IDE) used for building applications for iOS, macOS, watchOS, and tvOS. It includes the Swift compiler and all necessary tools.

- **How to check if you have it**: Search for "Xcode" on your Mac. If it's installed, you'll find it.
- **How to get it**: Download and install it from the Apple App Store on your Mac.

### A Code Editor

You'll need a text editor to view and edit the project's files. Xcode itself is a powerful code editor, but Visual Studio Code (VS Code) is also a popular and free choice for general code editing.

- **How to get it**: Download VS Code from [code.visualstudio.com](https://code.visualstudio.com).

## Setup Guide (Getting the Project Ready)

Now, let's get the project files onto your computer and set up the online database.

### Step 1: Clone the Repository

First, we need to download the project's code.

**Open your Terminal:**

On macOS: Search for "Terminal".

**Navigate to where you want to save the project:**

For example:

- **cd Desktop
- **mkdir Projects
- **cd Projects 

Clone the project:
git clone https://github.com/Hariom009/ColorGenerator-Assignment

This will create a new folder named ColorCode (or whatever your repository is named) with all the project files inside it.

Go into the project folder:
 - cd ColorCode

### Step 2: Install Project Dependencies

1. For Swift/SwiftUI projects, dependencies are typically managed by Xcode itself using Swift Package Manager, or sometimes by a tool like CocoaPods.

2. Open the Project in Xcode: Navigate to your ColorCode project folder and double-click the .xcodeproj or .xcworkspace file.

3. Xcode Handles Dependencies: Xcode will usually detect and download any required Swift Packages automatically.

### Step 3: Firebase Setup (The Online Database Part)

- **This project uses Google's Firebase for its online database.
- **Create a Firebase Project
- **Go to Firebase Console

- **Sign in with your Google Account.
- **Click "Add project".
- **Give your project a name (e.g., "MyColorCodeApp").
- **Follow the prompts and click "Create project".

# Add iOS App
- **Click the iOS icon in your Firebase project dashboard.
- **Enter your iOS Bundle ID (from Xcode: General > Bundle Identifier).
- **(Optional) App Nickname and App Store ID.
- **Click "Register app".

- **Download GoogleService-Info.plist
- **Download the GoogleService-Info.plist file.
- **In Xcode, drag the file into your Project Navigator.

Make sure "Copy items if needed" and your app target are selected.

# Set Up Firestore -
- **In Firebase Console, go to Firestore Database.
- **Click "Create database" > "Start in test mode".
- **Choose a location (e.g., nam5 for India) > Click "Enable".


## How to Run the Project : 

- **Open .xcodeproj or .xcworkspace in Xcode.
- **Select a simulator/device (e.g., iPhone 15 Pro).
- **Click the Run button (play icon).

You should now see the ColorCode application running! Try generating some colors and observe local and cloud syncing behavior.

## How It Works: 

- **Generating Colors: The app picks 3 random numbers (RGB) and turns them into a hex string.
- **Local Storage: Uses UserDefaults to store ID, hex code, and timestamp.
- **Firebase: Saves the same data to Firestore when online.
- **Network Monitor: Uses tools like NWPathMonitor to check internet status.
- **Smart Syncing:
- **Online: Save to both local and Firebase.
- **Offline → Online: Sync unsynced local data to Firebase.
