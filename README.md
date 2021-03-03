# memorypath_app

![Coveralls github](https://img.shields.io/coveralls/github/Memory-Path/memorypath_app?style=for-the-badge) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Memory-Path/memorypath_app/CI?label=tests&style=for-the-badge) 

Collaboration Base for the Memory-Path-Team

## Getting started

Register for the MapBox API, copy `lib/mapbox_api_key.dart.example` to `lib/mapbox_api_key.dart` and fill in your API key.

## Repository design

Our default branch is called `main`. Here, you can always find the latest features. This branch should always be buildable using Flutter's `dev` channel.

Aside, we still have the `stable` branch. Wekk, it's *stable*. The code is hence tested and ysyally up to date with the released Apps un the stores. All tags should be taken from the `stable` branch.

All other branches are potentially unsatble and commonly not buildable. Here, we play around with new features and ideas.
