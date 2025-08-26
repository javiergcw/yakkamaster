import 'package:flutter/material.dart';
import '../../data/wallet_dto.dart';

class TransactionItem extends StatelessWidget {
  final WalletDto transaction;
  final double horizontalPadding;
  final double verticalSpacing;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.horizontalPadding,
    required this.verticalSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWithdrawn = transaction.type == 'withdrawn';
    final iconColor = isWithdrawn ? Colors.red[600]! : Colors.green[600]!;
    final statusColor = isWithdrawn ? Colors.red[600]! : Colors.green[600]!;
    final icon = isWithdrawn ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalSpacing * 0.8,
      ),
      child: Row(
        children: [
          // Icono de transacción con estilo Apple
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          
          SizedBox(width: horizontalPadding * 0.8),
          
          // Información de la transacción
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.transactionId,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${transaction.amount >= 0 ? '+' : ''}${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          
          // Fecha y estado con estilo Apple
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(transaction.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  transaction.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }
}

