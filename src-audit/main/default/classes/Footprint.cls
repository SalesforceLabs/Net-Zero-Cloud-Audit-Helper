public with sharing class Footprint {
    public String fullname;
    public Map<String, Item> items;

    public Footprint(String fullname, Map<String, Item> items) {
        this.fullname = fullname;
        this.items = items;
    }

    public class Item {
        public String fullName;
        public String parentRelationshipName;

        public Item(String fullname, String parentRelationshipName) {
            this.parentRelationshipName = parentRelationshipName;
            this.fullname = fullname;
        }
    }
}