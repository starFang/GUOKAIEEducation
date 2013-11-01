#include <iostream>
#include <string>
#include <vector>
#include <sstream>
//#include "QZKernelBaseType.h"
//#include "QZKernelType.h"
#include "QZEpubPageDef.h"
using namespace std;

string str_replace(const string find, const string replace, string str)
{
	QZ_INT len = find.length();
	QZ_INT replace_len = replace.length();
	QZ_INT pos = str.find(find);

	while(pos != string::npos)
	{  
		str.replace(pos, len, replace);
		pos = str.find(find, pos + replace_len);
	}
	return str;
}

QZ_BOOL ctype_space(const QZ_CHAR c)
{
	return (c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == 11);
}

const string trim(const string istring)
{
	std::string::size_type first = istring.find_first_not_of(" \n\t\r\0xb");
	if (first == std::string::npos) {
		return std::string();
	}
	else {
		std::string::size_type last = istring.find_last_not_of(" \n\t\r\0xb");
		return istring.substr( first, last - first + 1);
	}
}


std::vector<std::string> split(const std::string sString,std::string strSplit)
{
	std::vector<std::string> splitString;
	if (sString.empty())
	{
		return splitString;
	}

	QZ_UINT uPrePos = 0;
	QZ_UINT length = sString.length();
	for (QZ_UINT uPos = 0;uPos < length;uPos++)
	{
		QZ_INT pos = strSplit.find(sString[uPos]);
		if (pos >= 0)
		{
			string strTem = sString.substr(uPrePos,uPos-uPrePos);
			if (!strTem.empty())
				splitString.push_back(strTem);
			uPrePos = uPos+1;
		}
	}

	if (length > uPrePos)
	{
		string strTem = sString.substr(uPrePos,length-uPrePos);
		if (!strTem.empty())
			splitString.push_back(strTem);
	}

	return splitString;
}

std::vector<std::string> split(const std::string sString,QZ_CHAR C)
{
	std::vector<std::string> splitString;
	if (sString.empty())
	{
		return splitString;
	}

	QZ_UINT uPrePos = 0;
	QZ_UINT length = sString.length();
	for (QZ_UINT uPos = 0;uPos < length;uPos++)
	{
		if (sString[uPos] == C)
		{
			string strTem = sString.substr(uPrePos,uPos-uPrePos);
			if (!strTem.empty())
				splitString.push_back(strTem);
			uPrePos = uPos+1;
		}
	}

	if (length > uPrePos)
	{
		string strTem = sString.substr(uPrePos,length-uPrePos);
		if (!strTem.empty())
			splitString.push_back(strTem);
	}

	return splitString;
}

std::vector<std::string> splitWithQuoteString(const std::string sString,QZ_CHAR C)
{
	std::vector<std::string> splitString;
	if (sString.empty())
	{
		return splitString;
	}

	QZ_UINT uPrePos = 0;
	QZ_UINT length = sString.length();
	QZ_BOOL isInString = QZ_FALSE;
	QZ_CHAR signalChar = '"';
	for (QZ_UINT uPos = 0;uPos < length;uPos++)
	{
		if (sString[uPos] == C && !isInString)
		{
			string strTem = sString.substr(uPrePos,uPos-uPrePos);
			if (!strTem.empty())
				splitString.push_back(strTem);
			uPrePos = uPos+1;
		}
		else
		{
			switch(sString[uPos])
			{
			case '"':
				if (isInString == QZ_FALSE)
				{
					isInString = QZ_TRUE;
					signalChar = '"';
				}
				else
				{
					if (signalChar == '\'')
						break;
					else
						isInString = QZ_FALSE;
				}
				break;
			case '\'':
				if (isInString == QZ_FALSE)
				{
					isInString = QZ_TRUE;
					signalChar = '\'';
				}
				else
				{
					if (signalChar == '"')
						break;
					else
						isInString = QZ_FALSE;
				}
				break;
			case '\\':
				if (isInString)
					uPos++;
				break;
			}
		}
	}

	if (length > uPrePos)
	{
		string strTem = sString.substr(uPrePos,length-uPrePos);
		if (!strTem.empty())
			splitString.push_back(strTem);
	}

	return splitString;
}

// Save replacement for .at()
QZ_CHAR s_at(const string &istring, const QZ_LONG pos)
{
	if(pos > (QZ_LONG)(istring.length()-1) && pos < 0)
	{
		return 0;
	}
	else
	{
		return istring[pos];
	}
}

QZ_CHAR chartolower(const QZ_CHAR c)
{
	switch(c)
	{
	case 'A': return 'a';
	case 'B': return 'b';
	case 'C': return 'c';
	case 'D': return 'd';
	case 'E': return 'e';
	case 'F': return 'f';
	case 'G': return 'g';
	case 'H': return 'h';
	case 'I': return 'i';
	case 'J': return 'j';
	case 'K': return 'k';
	case 'L': return 'l';
	case 'M': return 'm';
	case 'N': return 'n';
	case 'O': return 'o';
	case 'P': return 'p';
	case 'Q': return 'q';
	case 'R': return 'r';
	case 'S': return 's';
	case 'T': return 't';
	case 'U': return 'u';
	case 'V': return 'v';
	case 'W': return 'w';
	case 'X': return 'x';
	case 'Y': return 'y';
	case 'Z': return 'z';
	default: return c;
	}
}

QZ_BOOL ctype_digit(const QZ_CHAR c)
{
	return (c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9');
}

QZ_BOOL ctype_xdigit(QZ_CHAR c)
{
	c = chartolower(c);
	return (ctype_digit(c) || c == 'a' || c == 'b' || c == 'c' || c == 'd' || c == 'e' || c == 'f');
}

QZ_BOOL ctype_alpha(QZ_CHAR c)
{
	c = chartolower(c);
	return (c == 'a' || c == 'b' || c == 'c' || c == 'd' || c == 'e' || c == 'f' || c == 'g' || c == 'h' || c == 'i' || c == 'j' || 
		c == 'k' || c == 'l' || c == 'm' || c == 'n' || c == 'o' || c == 'p' || c == 'q' || c == 'r' || c == 's' || c == 't' || 
		c == 'u' || c == 'v' || c == 'w' || c == 'x' || c == 'y' || c == 'z');
}

QZ_BOOL isWordChar(QZ_CHAR c)
{
	return (ctype_alpha(c) || ctype_digit(c) || c == '_' || c == '-');
}

QZ_BOOL StrICompare(string str1,string str2)
{
	QZ_INT uSize = str1.size();

	for (QZ_INT pos = 0;pos < uSize;pos++)
		str1[pos] = chartolower(str1[pos]);

	uSize = str2.size();

	for (QZ_INT pos = 0;pos < uSize;pos++)
		str2[pos] = chartolower(str2[pos]);

	return str1==str2;
}

QZ_BOOL IntegerNumberCheck(string strValue)
{
	strValue = trim(strValue);
	if (strValue.empty())
		return QZ_FALSE;

	QZ_INT uSize = strValue.size();
	for (QZ_INT i = 0;i < uSize;i++)
		if (!ctype_digit(strValue[i]))
		{
			if(i==0 && strValue[i] == '-')
				continue;
			else
				return QZ_FALSE;
		}

	return QZ_TRUE;
}

QZ_BOOL FloatNumberCheck(string strValue)
{
	strValue = trim(strValue);
	if (strValue.empty())
		return QZ_FALSE;

	QZ_INT uPos = strValue.find('.');

	QZ_INT uSize = strValue.size();
	for (QZ_INT i = 0;i < uSize;i++)
		if (i != uPos && !ctype_digit(strValue[i]))
		{
			if(i==0 && strValue[i] == '-')
				continue;
			else
				return QZ_FALSE;
		}
	return QZ_TRUE;
}

QZ_BOOL PercentIntegerCheck(string strValue)
{
	strValue = trim(strValue);
	if (strValue.empty())
		return QZ_FALSE;
	
	QZ_INT uLength = strValue.length() - 1;

	return strValue[uLength]=='%'&&IntegerNumberCheck(strValue.substr(0,uLength));
}

QZ_BOOL PercentFloatNumberCheck(string strValue)
{
	strValue = trim(strValue);
	if (strValue.empty())
		return QZ_FALSE;

	QZ_INT uLength = strValue.length() - 1;

	return strValue[uLength]=='%'&&FloatNumberCheck(strValue.substr(0,uLength));
}

QZ_DOUBLE StringToDouble(string strDouble)
{
	stringstream ss(strDouble);
	QZ_DOUBLE d = 0.0;
	ss >> d;

	return d;
}

QZ_LONG	StringToLongInt(string strLong)
{
	QZ_LONG result = 0L;
	stringstream ss(strLong);
	ss >> result;

	return result;
}

QZ_INT	StringToInt(string strInt)
{
	QZ_INT result = 0;
	stringstream ss(strInt);
	ss >> result;

	return result;
}

QZ_ARGBCOLOR StringToARGBColor(string color)
{
	QZ_ARGBCOLOR argbColor;

	if (color.length() == 7 && 
		color[0] == '#' && 
		ctype_xdigit(color[1]) && 
		ctype_xdigit(color[2]) && 
		ctype_xdigit(color[3]) && 
		ctype_xdigit(color[4]) && 
		ctype_xdigit(color[5]) && 
		ctype_xdigit(color[6]))
	{
		stringstream ss(color.substr(1,2));
		ss >> hex >> argbColor.rgbRed;
		stringstream ss1(color.substr(3,2));
		ss1 >> hex >> argbColor.rgbGreen;
		stringstream ss2(color.substr(5,2));
		ss2 >> hex >> argbColor.rgbBlue;
	}

	return argbColor;
}

string Base16Encode(string str)
{
    string strTem = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    string strResult;
    for (long i = 0; i < (long)str.length(); i++)
    {
        short int val = str[i];
        short int val1 = (val >> 4)&15;
        short int val2 = val & 15;
        
        strResult = strResult + strTem[val1] + strTem[val2];
    }
    
    return strResult;
}

string GetBase16Name(string filename)
{
    vector<string> vs = split(filename,'.');
    string newFile = Base16Encode(vs[0]);
    if (filename.size() > 1)
    {
        newFile += "."+vs[1];
    }
    
    return  newFile;
}
