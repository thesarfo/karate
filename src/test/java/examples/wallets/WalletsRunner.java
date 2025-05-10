package examples.wallets;

import com.intuit.karate.junit5.Karate;

public class WalletsRunner {

    @Karate.Test
    Karate testWallets() {
        return Karate.run("wallets").relativeTo(getClass());
    }
}

