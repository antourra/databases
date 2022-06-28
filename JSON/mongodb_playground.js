//mostrar instancias
show dbs;

//crea y usa
use test;

//revisar version
db.version();
let version = db.version();

//borra la base de datos en uso
db.dropDatabase();

//https://docs.mongodb.com/manual/reference/method/db.createCollection/
db.createCollection("mds7103");
db.mds7103.drop();

//https://docs.mongodb.com/manual/reference/method/db.collection.insertOne/
db.mds7103.insertOne({id:1,nombre:"Pipe",cantidad:10000,chilean:true});
db.mds7103.insertOne({_id:3,nombre:"Pipe",cantidad:200,otro_json:{nombre:"Barby"}});
db.mds7103.insertOne({_id:2,nombre:"Barby",cantidad:200, numeros: [1,2,3]});

//https://docs.mongodb.com/manual/reference/method/db.collection.updateOne/
db.mds7103.updateOne({_id:2},{$set: {id:123},$inc: { cantidad: 2 }});

//https://docs.mongodb.com/manual/reference/method/db.collection.deleteOne/
db.mds7103.deleteOne({id:1})

//https://docs.mongodb.com/manual/reference/method/db.collection.find/
db.mds7103.find()
db.mds7103.find({nombre:"Barby"})

//https://docs.mongodb.com/manual/reference/operator/aggregation/sum/
db.mds7103.aggregate(
    [
//     {$match : { nombre : "Pipe" }},
        {
            $group:
                {
                    _id: "$nombre",
                    totalAmount: { $sum: { $multiply: [ "$cantidad", 2 ] } },
                    count: { $sum: 1 },
                }
        },
//     { $limit: 1 }
    ]
)

// mayor o menor
// https://www.mongodb.com/docs/manual/reference/operator/query/gt/
// https://www.mongodb.com/docs/manual/reference/operator/query/lt/
db.mds7103.aggregate(
    [
        {
            $match : { cantidad : { $gt: 1000 } }
        },
        {
            $group:
                {
                    _id: "$nombre",
                    totalAmount: { $sum: { $multiply: [ "$cantidad", 2 ] } },
                    count: { $sum: 1 },
                }
        },
    ]
)

// like
db.mds7103.aggregate(
    [
        {
            $match : { nombre : /arb/ }
        },
        {
            $group:
                {
                    _id: "$nombre",
                    totalAmount: { $sum: { $multiply: [ "$cantidad", 2 ] } },
                    count: { $sum: 1 },
                }
        },
    ]
)

// buscar adentro de un array y usamos or en match
db.mds7103.aggregate(
    [
        {
            $match : {
                $or: [
                  {  nombre : /arb/  },
                  {  nombre : /ip/  },
                ]
            }
        },
        {
            $group:
                {
                    _id: "$nombre",
                    totalAmount: { $sum: { $multiply: [ { $sum:"$otro_json.numeros"}, 2 ] } },
                    count: { $sum: 1 },
                    suma_otro_json_numeros: { $sum: {$sum:"$otro_json.numeros"} }
                }
        },
    ]
)
