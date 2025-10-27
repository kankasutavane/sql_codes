// Create a customer collection consisting of fields like name, email ID, profession, gender, bill amount
db.createCollection('Customer');
db.customer.insertMany([
    { name: "Alice", email: "alice@example.com", profession: "Engineer", gender: "Female", bill_amount: 4500 },
    { name: "Bob", email: "bob@example.com", profession: "Business", gender: "Male", bill_amount: 6200 },
    { name: "Charlie", email: "charlie@example.com", profession: "Doctor", gender: "Male", bill_amount: 7200 },
    // Add more customers as needed...
]);


// 	Write a MapReduce query for finding the count of male and female customers in the collection
var mapGenderCount = function() { // Map function
    emit(this.gender, 1);
};
var reduceGenderCount = function(key, values) { // Reduce function
    return Array.sum(values);
};
db.customer.mapReduce(mapGenderCount, reduceGenderCount, { out: "gender_count" }); // Run MapReduce
db.gender_count.find(); // Display the result

// 	Write a MapReduce query for finding the count of each profession in the collection
var mapProfessionCount = function() { // Map function
    emit(this.profession, 1);
};
var reduceProfessionCount = function(key, values) { // Reduce function
    return Array.sum(values);
};
db.customer.mapReduce(mapProfessionCount, reduceProfessionCount, { out: "profession_count" }); // Run MapReduce
db.profession_count.find(); // Display the result

// Display list of all customers with bill amounts greater than 5000/-
db.customer.find({ bill_amount: { $gt: 5000 } },{});

// Update the bill amount of any one customer
db.customer.updateOne( // Update Alice's bill amount
    { name: "Alice" },
    { $set: { bill_amount: 5500 } }
);

// 	Display all customers with name starting with 'B'
db.customer.find({ name: { $regex: /^B/ } }); //use find regular expression 

// Display list of all customers with profession = “Business”
db.customer.find({ profession: "Business" });

// 	Display all customers in Descending order of  Bill amount
db.customer.find().sort({ bill_amount: -1 });

// Create an index on name field of customer collection. Also use the explain() function
// Create index on name field
db.customer.createIndex({ name: 1 });
db.customer.find({ name: "Bob" }).explain();