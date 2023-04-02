List<String> animalList = AnimalsCallouts.getAnimalList();
system.debug('Animal List: ' + animalList);

for (String animal : animalList) {
  system.debug('animal --' + animal);
}
