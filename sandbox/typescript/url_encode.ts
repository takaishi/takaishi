const url = "http://localhost/api/user/太郎?age=20";
console.log(encodeURI(url));
console.log(encodeURIComponent(url));
console.log(decodeURIComponent(url));
