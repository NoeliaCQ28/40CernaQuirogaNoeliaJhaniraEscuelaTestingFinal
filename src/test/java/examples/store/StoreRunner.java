package examples.store;

import com.intuit.karate.junit5.Karate;

class StoreRunner {

    @Karate.Test
    Karate testStore() {
        return Karate.run("store").relativeTo(getClass());
    }

}
