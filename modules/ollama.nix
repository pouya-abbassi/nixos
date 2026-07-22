{ pkgs, ... }: {

  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = "10.3.0";
      environmentVariables = {
        HIP_VISIBLE_DEVICES = "0";
        OLLAMA_KEEP_ALIVE = "1m";
        OLLAMA_GPU_LAYERS = "999";
      };
    };
    nextjs-ollama-llm-ui = {
      enable = true;
    };
  };
}
