## Some Notes on Questions to Think About
* Weather - cold and wet way worse than heat?
* How have usage patterns changed over time as stations were added
* Most popular station pairs
* Does use vary by local user zip codes vs visitors from far away zip codes
* are any patterns predictable
* no bikes or one bikes = lost revenue and frustrated customers could be mechanical
* full stations = 0 or 1 dock
* how much does a station being down cost
* usage patterns change by day of week
* fastest someone has ridden
* mininetworks are they islands eg rice, med-center
* super riders vs infrequent riders someone with an annual membership
* repeat single riders that might be better off with a membership 13/mo 79/yr 


8/14 and earlier has these unique fields:

    Checkout Dock
    Bike Checkout Method
    Return Dock
    Adjusted Charge

9/14 and after has these unique fields:

    Trip ID
    UserProgramName
    UserRole
    UserCity
    UserState
    UserCountry
    Adjustment Flag
    TripOver30Min
    LocalProgramFlag
    TripRouteCategory
    TripProgramName

And both have the following (using / to indicate fields that are labeled differently, but mean the same thing):

    User ID
    Zip/UserZip
    MembershipType
    Bike
    CheckoutDate/CheckoutDateLocal
    CheckoutTime/CheckoutTimeLocal
    CheckoutKiosk/CheckoutKioskName
    ReturnDate/ReturnDateLocal
    ReturnTime/ReturnTimeLocal
    ReturnKiosk/ReturnKioskName
    Distance
    EstimatedCarbonOffset
    EstimatedCaloriesBurned
    Duration
    BikeModel/BikeType
    Charge/UsageFee
    AdjustedDuration


