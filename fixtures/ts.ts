type User = {
	id: number
	name: string
}

function greet(user: User): string {
	return `Hello, ${user.name}`
}

const users: User[] = [
	{ id: 1, name: 'Alice' },
	{ id: 2, name: 'Bob' },
]

users.forEach((u) => console.log(greet(u)))
