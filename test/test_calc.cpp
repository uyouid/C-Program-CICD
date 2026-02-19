extern "C" {
#include "calc.h"
}

#include "CppUTest/TestHarness.h"

TEST_GROUP(CalcGroup){

};

TEST(CalcGroup, AddTest) { CHECK_EQUAL(5, add(2, 3)); }
