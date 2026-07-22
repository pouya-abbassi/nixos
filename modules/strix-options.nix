{ lib, ... }: {

  options.strix = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "pouya";
      description = "User to add to different groups";
    };
  };
}
