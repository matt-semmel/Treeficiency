# Treefficiency

  Treeficiency is a mobile app developed for Android/iOS that gamifies the reduction of energy usage by offering competition through leaderboards and incentivizing through rewards and a points system. Users can log their monthly energy usage from their power bill and track the power drawn from their appliances and log when those appliances are turned on or even the phantom energy usage when they’re simply plugged in. Logging this information and taking steps to reduce energy usage will earn the user points which will place them on the leaderboard and that they can redeem for rewards. 
  
### Project Walkthrough
#### Setting up Treefficiency
When the user opens the app for the first time, they are greeted with a login screen. By clicking on the login button, the typical google account login screen appears and asks the user to identify themselves. Once successful, the app transfers them to the home landing page. This page includes an overview of all the appliances the user has registered with the app (initially two demo appliances), the number of Tree Points the user has accumulated, and amount of energy the user has used.

#### Using Treefficiency
Once the user has set up their account with Treefficiency, they can add appliances, enter their monthly energy usage from recent energy bills, and track the energy usage of their appliances being plugged in and being turned on. Once they’ve added their appliances, they can press check boxes to represent plugging in and turning off each appliance. Additionally, if they press the graph icon in the top right corner, Treefficiency will generate a graph that displays how much energy the user consumes, their predicted energy usage this month using previous months’ data, and predicted energy usage this month based on the appliances registered and typical use.

#### Gamification
The app is gamified by the implementation of Tree Points and rewards. Tree points are calculated using the following steps. First, the user inputs their monthly energy usage from the past 3 months based on their energy bill. Treefficiency uses this to calculate an average energy usage. While the app is open, it compares the energy usage logged on the app to the amount of energy used during that amount of time on average during previous months. This difference in energy usage is associated by a carbon footprint, which can be converted to “Trees Carbon” based on the amount of carbon the average tree absorbs from the environment per year (48lbs). Take that number and multiply it by one thousand to calculate the number of Tree Points earned. The rewards available include different aesthetic changes to the app.

___
#### How to get started
Treefficiency uses flutter and dart to run. After downloading all the content, type the command `flutter run` and Treefficiency will download and run on your connected mobile device.
