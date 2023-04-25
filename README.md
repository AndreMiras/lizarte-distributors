# Lizarte Distributors

[Lizarte.com](https://www.lizarte.com/) [distributors search page](https://www.lizarte.com/buscador-distribuidores.aspx) is broken because they didn't enable Geocoding Service billing.
The error is:

```
Geocoding Service: You must enable Billing on the Google Cloud Project at
https://console.cloud.google.com/project/_/billing/enable
Learn more at https://developers.google.com/maps/gmp-get-started
jquery.storelocator.js:761 Uncaught Error: Geocode was not successful for the following reason: REQUEST_DENIED
```

This quick project fixes it.
