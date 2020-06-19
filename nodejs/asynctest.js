const networkRequest = () => {
    setTimeout(() => {
        console.log('Async Code');
    }, 2000);
};

console.log('Hello World');

networkRequest();

console.log('The End');