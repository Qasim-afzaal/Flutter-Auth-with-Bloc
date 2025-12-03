import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';

/// CounterPage provides the CounterBloc to its child widgets
/// BlocProvider makes the bloc available to all child widgets via context.read<CounterBloc>()
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter BLoC Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                final bloc = context.read<CounterBloc>();
                final status = bloc.getCounterStatus();
                return Column(
                  children: [
                    Text(
                      '${state.value}',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: $status',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    context.read<CounterBloc>().add(DecreaseNumber());
                  },
                  tooltip: 'Decrement',
                  heroTag: 'decrement',
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrease'),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    context.read<CounterBloc>().add(ResetNumber());
                  },
                  tooltip: 'Reset',
                  heroTag: 'reset',
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    context.read<CounterBloc>().add(IncreaseNumber());
                  },
                  tooltip: 'Increment',
                  heroTag: 'increment',
                  icon: const Icon(Icons.add),
                  label: const Text('Increase'),
                ),
                
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
