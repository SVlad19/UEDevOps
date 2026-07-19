// My game copyright

#pragma once

#include "CoreMinimal.h"
#include "Tests/Utils/InputRecordingUtils.h"

namespace <Name>
{
namespace Test
{

class JsonUtils
{
public:
    static bool WriteInputData(const FString& FileName, const FInputData& InputData);
    static bool ReadInputData(const FString& FileName, FInputData& InputData);
};

}  // namespace Test
}  // namespace <Name>
