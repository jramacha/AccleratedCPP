#include<iostream>
#include<vector>
#include<ios>
#include<iomanip>
#include<string>
#include<stdexcept>
#include "median.h"

using std::cout;	using std::cin;
using std::vector;	using std::string;
using std::streamsize;	using std::sort;
using std::setprecision; using std::endl;
using std::domain_error; using std::istream;

/*
double median(vector<double> vec)
{
	typedef vector<double>::size_type vec_sz;
	vec_sz size = vec.size();
	if (size == 0)
		throw domain_error("median of an empty vector");

	sort(vec.begin(),vec.end());
	
	vec_sz mid = size/2;
	
	return size % 2 == 0 ? (vec[mid] + vec[mid-1]) / 2 : vec[mid];
}
*/

double grade(double midterm, double final, double homework)
{
	return .2 * midterm + .4 * final + .4 * homework;
}

double grade(double midterm, double final, const vector<double>& hw)
{
	if (hw.size() == 0)
		throw domain_error("student has done no homework");
	return grade(midterm, final, median(hw));
}

istream& read_hw(istream& in, vector<double>& hw)
{
	if(in) {
		hw.clear();
		
		double x;
		while(in >> x)
			hw.push_back(x);
	
		in.clear();

	}
	return in;
}

int main()
{
	cout << "Enter your name";
	string name;
	cin >> name;

	cout << "hello " << name << endl;
	cout <<"Enter your midterm and final grade";
	
	double midterm,final;
	cin >> midterm >> final;

	cout << " enter your homework grades "
			"followed by eof";
	
	vector<double> homework;

	read_hw(cin, homework);

	try{
		double final_grade = grade(midterm,final,homework);
		streamsize prec = cout.precision();
		cout << "Your final grade is" << setprecision(3)
			<< final_grade << setprecision(prec) << endl;
	}	
	catch (domain_error) {
		cout << endl << "You must enter grade" ;
		return 1;
	}
	return 0;

}
