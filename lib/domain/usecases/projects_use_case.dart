import 'package:farm/domain/base/base.dart';
import 'package:farm/domain/entities/project/project.dart';
import 'package:farm/domain/entities/project/project_request.dart';
import 'package:farm/domain/repositories/repository.dart';
import 'package:farm/utils/domain_state.dart';
import 'package:farm/utils/response_mapper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'projects_use_case.freezed.dart';

@Injectable()
class ProjectsUseCase
    extends BaseFutureUseCase<ProjectRequest, ProjectsOutput> {
  const ProjectsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<ProjectsOutput> buildUseCase(ProjectRequest input) async {
    final response = await _repository.projects(input);
    final result = responseListMapper(response);
    return ProjectsOutput(result: result);
  }
}

@freezed
abstract class ProjectsOutput extends BaseOutput with _$ProjectsOutput {
  const ProjectsOutput._();

  const factory ProjectsOutput({DomainState<List<Project>>? result}) =
      _ProjectsOutput;
}
