class Employee{

 late String lang;
 late String image;
 late String dropdownItem;

  Employee(this.lang, this.image, this.dropdownItem);
  
   Employee.fromMap(Map map) {
     lang = map[lang];
     image = map[image];
     dropdownItem = map[dropdownItem];

  }

 Map<String, dynamic> toMap() {
   var map = <String, dynamic>{
     'lang': lang,
     'image': image,
     'dropdownItem': dropdownItem,
   };
   return map;
 }
  
}