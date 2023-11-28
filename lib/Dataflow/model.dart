import 'package:lattice_reports/Dataflow/http_model_base.dart';
import 'package:lattice_reports/Dataflow/identifiable.dart';
import 'package:preflection/Preflectable.dart';

abstract class Model<TModel> extends Preflectable<TModel>
    with Identifiable
    implements HttpModelBase {}
