// Doesn't work on dynamic created elements
// document.querySelector("button").addEventListener("click", function(){
//     console.log("Deleteing element")
// })

async function delete_user(user_id){
    try{
        console.log("Deleting user", user_id)
        const conn = await fetch(`/api/v1/users/${user_id}`, {
            method : "DELETE"
        }) 
    }catch(err){
        console.error(err)
    }
}




async function get_items(){
    try{
        const conn = await fetch("/api/v1/items")
        const items = await conn.json()
        console.log(items)
        let html = ""
        items.forEach(item => {
            console.log(item)
            html += `<div class="item">
                        <div>${item.user_pk}</div>
                        <div>${item.user_name}</div>
                        <button onclick="delete_user(${item.user_pk})">
                            Delete
                        </button>
                    </div>`            
        })
        document.querySelector("#items").insertAdjacentHTML("afterbegin", html)

    }catch(error){
        console.log(error)
    }
}

get_items()


// SSR 


