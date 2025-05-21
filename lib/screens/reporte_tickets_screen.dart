import 'package:flutter/material.dart';
import 'package:proyecto_moviles2/model/ticket_model.dart';
import 'package:proyecto_moviles2/services/ticket_service.dart';

class ReporteTicketsScreen extends StatefulWidget {
  @override
  _ReporteTicketsScreenState createState() => _ReporteTicketsScreenState();
}

class _ReporteTicketsScreenState extends State<ReporteTicketsScreen> {
  DateTime? fechaInicio;
  DateTime? fechaFin;

  Future<List<Ticket>>? _futureTickets;

  void _generarReporte() {
    if (fechaInicio != null && fechaFin != null) {
      _futureTickets = TicketService().obtenerTicketsPorRangoFecha(
        fechaInicio!,
        fechaFin!,
      );
      setState(() {});
    }
  }

  Future<void> _seleccionarFecha(BuildContext context, bool esInicio) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        if (esInicio) {
          fechaInicio = fecha;
        } else {
          fechaFin = fecha;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reporte de Tickets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => _seleccionarFecha(context, true),
                  child: Text(
                    fechaInicio == null
                        ? 'Desde'
                        : 'Desde: ${fechaInicio!.toLocal()}'.split(' ')[0],
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => _seleccionarFecha(context, false),
                  child: Text(
                    fechaFin == null
                        ? 'Hasta'
                        : 'Hasta: ${fechaFin!.toLocal()}'.split(' ')[0],
                  ),
                ),
                ElevatedButton(
                  onPressed: _generarReporte,
                  child: Text('Generar'),
                )
              ],
            ),
            Expanded(
              child: _futureTickets == null
                  ? Center(child: Text('Selecciona un rango de fechas'))
                  : FutureBuilder<List<Ticket>>(
                      future: _futureTickets,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No se encontraron tickets'));
                        }

                        final tickets = snapshot.data!;
                        return ListView.builder(
                          itemCount: tickets.length,
                          itemBuilder: (context, index) {
                            final ticket = tickets[index];
                            return ListTile(
                              title: Text(ticket.titulo),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Estado: ${ticket.estado}'),
                                  Text('Categoría: ${ticket.categoria}'),
                                  Text('Agente: ${ticket.usuarioNombre}'),
                                  Text('Fecha: ${ticket.fechaCreacion.toLocal()}'),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
