{
  services.redshift = {
    enable = true;
    provider = "manual";
    latitude = 47.2;
    longitude = 39.7;
    temperature = {
      day = 2700;
      night = 2300;
    };
  };
}
