{ ... }:

{
  powerManagement.enable = false;

  services = {
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        PLATFORM_PROFILE_ON_AC = "none";
        PLATFORM_PROFILE_ON_BAT = "none";

        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };
    asusd = {
      enable = true;
      asusdConfig.source = ./strix/asusd.ron;
      fanCurvesConfig.source = ./strix/fan_curves.ron;
    };

    supergfxd = {
      enable = true;
    };
  };
}
