import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotesbeginer/views/counter_bloc.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CounterBloc(),
        child: Scaffold(
          body: BlocConsumer<CounterBloc, CounterState>(
            listener: (context, state) {
              _textController.clear();
            },
            builder: (context, state) {
              final invalidValue =
                  state is CounterStateInvalidValue ? state.invalidValue : '';
              return Column(
                children: [
                  Text('CurrentValue: ${state.value}'),
                  Visibility(
                    visible: state is CounterStateInvalidValue,
                    child: Text('InvalidValue: $invalidValue'),
                  ),
                  TextField(
                    controller: _textController,
                    decoration:
                        const InputDecoration(hintText: 'Enter number here'),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecrementEvent(_textController.text));
                        },
                        child: const Text('-'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncrementEvent(_textController.text));
                        },
                        child: const Text('+'),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                context.read<CounterBloc>().add(const IncrementEvent('1')),
            child: const Icon(Icons.add),
          ),
        ));
  }
}
