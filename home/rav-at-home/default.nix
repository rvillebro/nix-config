# Thin identity seam for the rav@home standalone deployment.
# Imports the User home module and nothing else; future rav@home-specific
# facts land here.
{
  imports = [
    ../user
  ];
}
