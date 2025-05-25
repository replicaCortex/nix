{
  services.redshift = {
    enable = false;
    provider = "manual";
    latitude = 47.2;
    longitude = 39.7;
    temperature = {
      day = 2700;
      night = 2300;
    };
  };

  services.gammastep = {
    enable = true;
    temperature = {
      day = 4000;
      night = 4000;
    };
    latitude = -74.3;
    longitude = 12.5;
  };
}
