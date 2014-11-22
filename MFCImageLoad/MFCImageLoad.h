// MFCImageLoad.h

// .dll for loading images dynamically into UDK
// 16.04.2014 File Created by Mika Veikkolainen careless.oversight@gmail.com
// Based on code provided on UDK Forums by Ehamloptiran :
// https://forums.epicgames.com/threads/967633-Dynamic-player-driven-customizations-textures-for-players?p=31565123&viewfull=1#post31565123

#include <cstdio>
#include <iostream>
#include <wchar.h>

#pragma once

using namespace System;

typedef unsigned long DWORD, *PDWORD, *LPDWORD; 
typedef unsigned int INT;
typedef unsigned char BYTE;

template<typename DataType>
struct TArray
{
	DataType* Data;

	int Num() { return ArrayNum; }

	void Reallocate( int NewNum, bool bCompact=false )
	{
		ArrayNum = NewNum;
		if( ArrayNum > ArrayMax || bCompact )
		{
			ArrayMax = ArrayNum;
			Data = (DataType*)(*ReallocFunctionPtr)( Data, ArrayMax * sizeof( DataType ), 8 );
		}
	}

private:
	int ArrayNum;
	int ArrayMax;
};

extern "C"
{

    wchar_t aFileName[255];

	// Reallocation function pointer
        typedef void* (*ReallocFunctionPtrType)( void* Original, DWORD Count, DWORD Alignment );
	ReallocFunctionPtrType ReallocFunctionPtr = NULL;

	// Initialisation data
	struct FDLLBindInitData
	{
		INT Version;
		ReallocFunctionPtrType ReallocFunctionPtr;
	};

	struct ImageData
	{
		TArray<BYTE> Data;
	};

	// Automatically called Init function
	__declspec( dllexport ) void DLLBindInit( FDLLBindInitData* InitData )
	{
		ReallocFunctionPtr = InitData->ReallocFunctionPtr;
	}

	__declspec(dllexport) bool DLLSetName(wchar_t* aName)
	{
		wcscpy_s(aFileName,aName);
		return true;
	}

	__declspec( dllexport ) void DLLGetData( struct ImageData* ImportData )
	{
		FILE* pFile;
		fpos_t FilePos;
		char Value;
		int Idx = 0;

		_wfopen_s (&pFile, aFileName, L"rb" );
		if( pFile != NULL )
		{
			fseek( pFile, 0, SEEK_END );
			fgetpos( pFile, &FilePos );
			fseek( pFile, 0x80, SEEK_SET );

			ImportData->Data.Reallocate( (int) FilePos - 0x80 );
			
			for( int i = 0; i < (int)(FilePos - 0x80); i++ )
			{
				Value = fgetc( pFile );
				ImportData->Data.Data[i] = (BYTE) Value;
			}

			fclose( pFile );
		}
	}
}
