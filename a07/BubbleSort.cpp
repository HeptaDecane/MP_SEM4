#include<bits/stdc++.h>
using namespace std;
class Database{
	int n;
	float *array;
public:
	Database();
	Database(int);
	void read();
	void display();
	void swap(float*,float*);
	void bubbleSort();
};
Database::Database(){
	n=0;
	array=NULL;
}
Database::Database(int n){
	this->n=n;
	array=new float[this->n];
}
void Database::read(){
	cout<<"\nEnter Array Elements: ";
	for(int i=0;i<n;i++)
		cin>>array[i];
}
void Database::display(){
	cout<<"\nArray: ";
	for(int i=0;i<n;i++)
		cout<<array[i]<<" ";
}
void Database::swap(float *a,float *b){
	float temp=*a;
	*a=*b;
	*b=temp;
}
void Database::bubbleSort(){
	for(int i=0;i<n-1;i++){
		for(int j=0;j<n-i-1;j++){
			if(array[j+1]<array[j])
				swap(&array[j],&array[j+1]);
		}
	}
}
int main(){
	int n;
	cout<<"\nEnter Array Size: ";
	cin>>n;
	Database container(n);
	container.read();
	container.bubbleSort();
	container.display();
	return 0;
}
