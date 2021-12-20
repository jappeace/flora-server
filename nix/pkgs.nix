import ./pin.nix {
  config = {

    packageOverrides = pkgs: {
        haskell = pkgs.lib.recursiveUpdate pkgs.haskell {
          packageOverrides = hpNew: hpOld:
            let
            sourcePrometheus = fetchTarball {
                url = "https://github.com/fimad/prometheus-haskell/archive/43f19da.tar.gz";
                sha256 = "1xg3jyhy60xxhcwcl8sc55r7yzya0nqjl8bchms6cvfnzldrcih5";
            };
            in
            {
            flora-server = hpNew.callPackage ../default.nix {};
            wai-middleware-heartbeat = hpNew.callCabal2nix "wai-middleware-heartbeat" (fetchTarball {
                url = "https://github.com/flora-pm/wai-middleware-heartbeat/archive/bd7dbbe.tar.gz";
                sha256 = "1s2flv2jhfnd4vdfg6rmvq7s852w1pypasdg0l6ih6raaqyqzybn";
            }) {};
            pg-transact = pkgs.haskell.lib.dontCheck (pkgs.haskell.lib.unmarkBroken hpOld.pg-transact);
            hspec-pg-transact = pkgs.haskell.lib.dontCheck (hpOld.hspec-pg-transact);
            postgresql-migration = pkgs.haskell.lib.unmarkBroken hpOld.postgresql-migration;
            text-display = pkgs.haskell.lib.unmarkBroken hpOld.text-display;
            pg-entity = pkgs.haskell.lib.dontCheck hpOld.pg-entity;

            servant-lucid = hpOld.callHackage "servant-lucid" "0.9.0.3" {};
            };
        };
    };
  };
}
