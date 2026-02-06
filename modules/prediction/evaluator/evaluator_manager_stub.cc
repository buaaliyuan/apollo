// Stub evaluator_manager implementation for non-GPU/non-torch builds.
// This provides empty implementations so that the prediction module compiles
// without libtorch, but the evaluators are non-functional.
#include "modules/prediction/evaluator/evaluator_manager.h"

#include "cyber/common/log.h"

namespace apollo {
namespace prediction {

EvaluatorManager::EvaluatorManager() {}

void EvaluatorManager::Init(const PredictionConf& config) {
  AWARN << "EvaluatorManager: libtorch not available, evaluators disabled.";
}

Evaluator* EvaluatorManager::GetEvaluator(
    const ObstacleConf::EvaluatorType& type) {
  return nullptr;
}

void EvaluatorManager::Run(
    const ADCTrajectoryContainer* adc_trajectory_container,
    ObstaclesContainer* obstacles_container) {}

void EvaluatorManager::EvaluateObstacle(
    const ADCTrajectoryContainer* adc_trajectory_container,
    Obstacle* obstacle,
    ObstaclesContainer* obstacles_container,
    std::vector<Obstacle*> dynamic_env) {}

void EvaluatorManager::EvaluateObstacle(
    Obstacle* obstacle,
    ObstaclesContainer* obstacles_container) {}

void EvaluatorManager::EvaluateMultiObstacle(
    const ADCTrajectoryContainer* adc_trajectory_container,
    ObstaclesContainer* obstacles_container) {}

void EvaluatorManager::BuildObstacleIdHistoryMap(
    ObstaclesContainer* obstacles_container, size_t max_num_frame) {}

void EvaluatorManager::DumpCurrentFrameEnv(
    ObstaclesContainer* obstacles_container) {}

void EvaluatorManager::RegisterEvaluator(
    const ObstacleConf::EvaluatorType& type) {}

std::unique_ptr<Evaluator> EvaluatorManager::CreateEvaluator(
    const ObstacleConf::EvaluatorType& type) {
  return nullptr;
}

void EvaluatorManager::RegisterEvaluators() {}

}  // namespace prediction
}  // namespace apollo
