export {}
let message = "Hello Again!";
console.log(message);

let x = 10;
const y = 20;

let sum;
const titles = 'Codevolution';

let isBeginner: boolean = true;
let total: number = 0;
let name: string = 'Matias';

let sentance: string = `My name is ${name}
I am a beginner in Typescript`;

console.log(sentance)

let n: null = null;
let u: undefined = undefined;

let isNew: boolean = null;
let myName: string = undefined;

let list1: number[] = [1,2,3];
let list2: Array<number> = [1,2,3];

let person1: [string, number] = ['Chris', 22];

enum Color {Red, Green, Blue};

let c: Color = Color.Green;

console.log(c);

let a;
a = 10;
a = true;

let b = 20;

let multiType: number | boolean;
multiType = 20;
multiType = true;

let anyType: any;
anyType = 20;


function add(num1: number, num2?: number): number {
    if (num2)
        return num1 + num2;
    else
        return num1;
}

add(5,10);
add(5);

function add2(num1: number, num2: number = 10): number {
    if (num2)
        return num1 + num2;
    else
        return num1;
}

add2(5)

interface Person {
    firstName: string;
    lastName: string;
}

function fullName(person: Person) {
    console.log(`${person.firstName} ${person.lastName}`);
}

let p = {
    firstName: 'Bruce',
    lastName: 'Wayne'
};

fullName(p)

class Employee {
    employeeName: string;

    constructor(name: string) {
        this.employeeName = name;
    }

    greet() {
        console.log(`Good Morning ${this.employeeName}`);
    }
}

let emp1 = new Employee('Matias');
console.log(emp1.employeeName);
emp1.greet();

class Manager extends Employee {
    constructor(managerName: string) {
        super(managerName);
    }

    delegateWork() {
        console.log('Manager delegating tasks')
    }
}

let m1 = new Manager('Christine')
m1.delegateWork();
m1.greet();
console.log(m1.employeeName)
