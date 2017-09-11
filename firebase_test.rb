require 'firebase'

base_uri = "https://shoppinglist1901.firebaseio.com/"

firebase = Firebase::Client.new(base_uri)

response = firebase.push("shoppingListItems", {itemName: "Egg", owner: "Adi Nugroho"})
p response.success?
p response.code
p response.body
