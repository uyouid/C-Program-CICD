extern "C" {
#include "calc.h"
}

#include "CppUTest/TestHarness.h"

TEST_GROUP(CalcGroup){

};

TEST(CalcGroup, AddTest) { CHECK_EQUAL(5, add(2, 3)); }

TEST(CalcGroup, MinusTest) { CHECK_EQUAL(-1, minus(2, 3)); }
TEST(CalcGroup, MinusTest) { CHECK_EQUAL(2, minus(5, 3)); }
