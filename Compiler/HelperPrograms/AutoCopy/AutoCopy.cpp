// AutoCopy.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <windows.h>
#include <fstream>
#include <sstream>
#include <iostream>
#include <iomanip>
#include <string> 

using namespace std;

#define ARG_NUM_INPUT_BIN_FILE 1

std::string hexStr(uint32_t data){
	std::stringstream ss;
	ss << std::hex;

	ss << std::setw(8) << std::setfill('0') << (int)(data);

	return ss.str();
}

void toClipboard(const std::string& s) {
	OpenClipboard(0);
	EmptyClipboard();
	HGLOBAL hg = GlobalAlloc(GMEM_MOVEABLE, s.size());
	if (!hg) {
		CloseClipboard();
		return;
	}
	memcpy(GlobalLock(hg), s.c_str(), s.size());
	GlobalUnlock(hg);
	SetClipboardData(CF_TEXT, hg);
	CloseClipboard();
	GlobalFree(hg);
}

int main(int numArgs, char* args[]){
	cout << "Reading from File: " << args[ARG_NUM_INPUT_BIN_FILE] << "\n";

	ifstream inputFile;
	inputFile.open(args[ARG_NUM_INPUT_BIN_FILE], ios::in | ios::ate | ios::binary);

	BYTE* data;
	string msg = "";

	if (inputFile.is_open()) {
		int length = inputFile.tellg();
		data = new BYTE[length];
		
		inputFile.seekg(0, ios::beg);
		inputFile.read((char*)data, length);
		inputFile.close();

		int ramUsed = 0;

		for (int i = 0; i < length/4; i++) {
			msg += "Ram[";
			msg += std::to_string(ramUsed);
			msg += "] = 32'h";
			msg += hexStr((uint32_t)(((data[(i * 4) + 3]) << 24) | ((data[(i * 4) + 2]) << 16) | ((data[(i * 4) + 1]) << 8) | ((data[i*4]) << 0)));
			msg += ";\n";
			ramUsed++;
		}

		msg += "numRamUsed = ";
		msg += std::to_string(ramUsed);
		msg += ";\n";

		cout << msg;
		cout << "copied data to clipboard\n";

		toClipboard(msg.c_str());
	}else {
		cout << "Failed to open " << args[ARG_NUM_INPUT_BIN_FILE] << "\n";
	}
}

