import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DealFormScreen extends StatefulWidget {
  const DealFormScreen({super.key});

  @override
  State<DealFormScreen> createState() => _DealFormScreenState();
}

class _DealFormScreenState extends State<DealFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final dealName = TextEditingController();
  final company = TextEditingController();
  final contactPerson = TextEditingController();
  final designation = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();

  final product = TextEditingController();
  final quantity = TextEditingController();
  final estimatedValue = TextEditingController();
  final quotationNo = TextEditingController();
  final quotationValue = TextEditingController();
  final discount = TextEditingController();

  final paymentTerms = TextEditingController();
  final deliveryTimeline = TextEditingController();
  final requirements = TextEditingController();
  final notes = TextEditingController();
  final competitor = TextEditingController();

  String stage = 'New Opportunity';
  String priority = 'Medium';
  String source = 'Direct';
  String salesOwner = 'Unassigned';

  double probability = 20;

  final sources = [
    'Direct',
    'Phone Call',
    'WhatsApp',
    'Email',
    'Website',
    'IndiaMART',
    'TradeIndia',
    'Justdial',
    'Google',
    'Facebook',
    'Instagram',
    'LinkedIn',
    'Reference',
    'Existing Customer',
    'Exhibition',
    'Dealer / Distributor',
    'Other',
  ];

  final stages = [
    'New Opportunity',
    'Qualification',
    'Requirement',
    'Quotation',
    'Negotiation',
    'Purchase Order',
    'Won',
    'Lost',
  ];

  final owners = [
    'Unassigned',
    'Sales Manager',
    'Sales Executive 1',
    'Sales Executive 2',
    'BDM',
  ];

  Future<void> _saveDeal() async {
    if (!_formKey.currentState!.validate()) return;

    final value = double.tryParse(estimatedValue.text) ?? 0;

    await FirebaseFirestore.instance.collection('deals').add({
      'dealName': dealName.text.trim(),
      'company': company.text.trim(),
      'contactPerson': contactPerson.text.trim(),
      'designation': designation.text.trim(),
      'mobile': mobile.text.trim(),
      'email': email.text.trim(),

      'product': product.text.trim(),
      'quantity': quantity.text.trim(),

      'estimatedValue': value,

      'quotationNo': quotationNo.text.trim(),
      'quotationValue':
          double.tryParse(quotationValue.text) ?? 0,
      'discount': double.tryParse(discount.text) ?? 0,

      'paymentTerms': paymentTerms.text.trim(),
      'deliveryTimeline': deliveryTimeline.text.trim(),

      'requirements': requirements.text.trim(),
      'notes': notes.text.trim(),
      'competitor': competitor.text.trim(),

      'stage': stage,
      'priority': priority,
      'source': source,
      'salesOwner': salesOwner,
      'probability': probability,

      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deal created successfully'),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Deal',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle(
              'Opportunity Information',
              Icons.handshake_outlined,
            ),

            _field(
              dealName,
              'Deal / Opportunity Name',
              Icons.title,
              required: true,
            ),

            _field(
              company,
              'Company / Customer',
              Icons.business_outlined,
              required: true,
            ),

            _field(
              contactPerson,
              'Contact Person',
              Icons.person_outline,
            ),

            Row(
              children: [
                Expanded(
                  child: _field(
                    designation,
                    'Designation',
                    Icons.badge_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    mobile,
                    'Mobile / WhatsApp',
                    Icons.phone_outlined,
                  ),
                ),
              ],
            ),

            _field(
              email,
              'Email Address',
              Icons.email_outlined,
            ),

            const SizedBox(height: 20),

            _sectionTitle(
              'Deal Classification',
              Icons.category_outlined,
            ),

            _dropdown(
              label: 'Deal Stage',
              value: stage,
              items: stages,
              onChanged: (value) {
                if (value != null) {
                  setState(() => stage = value);
                }
              },
            ),

            _dropdown(
              label: 'Lead / Deal Source',
              value: source,
              items: sources,
              onChanged: (value) {
                if (value != null) {
                  setState(() => source = value);
                }
              },
            ),

            _dropdown(
              label: 'Priority',
              value: priority,
              items: const [
                'Low',
                'Medium',
                'High',
                'Critical',
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => priority = value);
                }
              },
            ),

            _dropdown(
              label: 'Sales Owner',
              value: salesOwner,
              items: owners,
              onChanged: (value) {
                if (value != null) {
                  setState(() => salesOwner = value);
                }
              },
            ),

            const SizedBox(height: 20),

            _sectionTitle(
              'Product & Commercial Details',
              Icons.inventory_2_outlined,
            ),

            _field(
              product,
              'Product / Service',
              Icons.inventory_outlined,
            ),

            Row(
              children: [
                Expanded(
                  child: _field(
                    quantity,
                    'Quantity',
                    Icons.numbers,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    estimatedValue,
                    'Estimated Deal Value',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: _field(
                    quotationNo,
                    'Quotation No.',
                    Icons.receipt_long_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    quotationValue,
                    'Quotation Value',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            _field(
              discount,
              'Discount %',
              Icons.discount_outlined,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            _sectionTitle(
              'Sales Probability',
              Icons.analytics_outlined,
            ),

            Text(
              'Probability: ${probability.toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            Slider(
              value: probability,
              min: 0,
              max: 100,
              divisions: 20,
              label: '${probability.toInt()}%',
              onChanged: (value) {
                setState(() {
                  probability = value;
                });
              },
            ),

            const SizedBox(height: 20),

            _sectionTitle(
              'Commercial Terms',
              Icons.description_outlined,
            ),

            _field(
              paymentTerms,
              'Payment Terms',
              Icons.payments_outlined,
            ),

            _field(
              deliveryTimeline,
              'Delivery Timeline',
              Icons.local_shipping_outlined,
            ),

            _field(
              competitor,
              'Competitor',
              Icons.groups_outlined,
            ),

            const SizedBox(height: 20),

            _sectionTitle(
              'Requirements & Notes',
              Icons.notes_outlined,
            ),

            _field(
              requirements,
              'Customer Requirements',
              Icons.list_alt_outlined,
              maxLines: 4,
            ),

            _field(
              notes,
              'Internal Sales Notes',
              Icons.sticky_note_2_outlined,
              maxLines: 4,
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saveDeal,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Create Deal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          prefixIcon: const Icon(Icons.tune),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}