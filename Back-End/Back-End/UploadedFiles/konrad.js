let p = new Promise((resolve, reject) =>{
    let a = 1 + 1
    if (a == 2){
        resolve("Success")
    } else{
        reject("Failed!")
    }
})

p.then((message) =>{
    console.log("This is in the then " + message)
}).catch((message)=>{
    console.log("This is in the catch" + message)
})

function fetch(){
    $.ajax({
        url: 'https://opentdb.com/api.php?amount=1&category=18', 
        type: "GET", 
        //dataType: "JSON", 
        //data: JSON.stringify({ }),
        sucess:function(result){
            console.log(result)
        }

    });
}

fetch();