import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_provider.dart';
import 'order_draft.dart';
import 'order_entry_repository.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key, OrderEntryRepository? repository})
      : _repository = repository;

  final OrderEntryRepository? _repository;

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _piNumber = TextEditingController();
  final _orderDate = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  final _deliveryNeededOn = TextEditingController();
  final _assemblyDate = TextEditingController();
  final _dispatchDate = TextEditingController();
  final _companyName = TextEditingController();
  final _projectName = TextEditingController();
  final _projectTitle = TextEditingController();
  final _deliveryAddress = TextEditingController();
  final _clientName = TextEditingController();
  final _clientContactNumber = TextEditingController();
  final _customerEmailId = TextEditingController();
  final _advanceReceived = TextEditingController();
  final _basicOrderValue = TextEditingController();
  final _orderValueWithGst = TextEditingController();

  late final OrderEntryRepository _repository;
  List<String> _stages = [];
  List<String> _wipOptions = [];
  String? _stage;
  String? _wip;
  OrderAttachment? _piDocument;
  OrderAttachment? _bomQuotationDocument;
  OrderAttachment? _drawingDocument;
  String? _configurationError;
  bool _loadingConfigurations = true;
  bool _saving = false;
  bool _readyStock = false;

  @override
  void initState() {
    super.initState();
    _repository = widget._repository ??
        OrderEntryRepository(
          backend: SupabaseOrderEntryBackend(Supabase.instance.client),
        );
    _loadConfigurations();
  }

  @override
  void dispose() {
    _piNumber.dispose();
    _orderDate.dispose();
    _deliveryNeededOn.dispose();
    _assemblyDate.dispose();
    _dispatchDate.dispose();
    _companyName.dispose();
    _projectName.dispose();
    _projectTitle.dispose();
    _deliveryAddress.dispose();
    _clientName.dispose();
    _clientContactNumber.dispose();
    _customerEmailId.dispose();
    _advanceReceived.dispose();
    _basicOrderValue.dispose();
    _orderValueWithGst.dispose();
    super.dispose();
  }

  Future<void> _loadConfigurations() async {
    setState(() {
      _loadingConfigurations = true;
      _configurationError = null;
    });
    try {
      final results = await Future.wait([
        _repository.loadActiveOptions('stage'),
        _repository.loadActiveOptions('wip'),
      ]);
      if (!mounted) return;
      setState(() {
        _stages = results[0];
        _wipOptions = results[1];
        _stage = _stages.contains(_stage) ? _stage : null;
        _wip = _wipOptions.contains(_wip) ? _wip : null;
        _loadingConfigurations = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _configurationError = error.toString();
        _loadingConfigurations = false;
      });
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final selected = DateTime.tryParse(controller.text) ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 20),
    );
    if (date == null) return;
    controller.text = DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickDocument(String kind) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final picked = result.files.single;
      final bytes = picked.bytes;
      if (bytes == null) {
        throw StateError('The selected file could not be read.');
      }
      final attachment = OrderAttachment(name: picked.name, bytes: bytes);
      setState(() {
        switch (kind) {
          case 'pi':
            _piDocument = attachment;
          case 'bom':
            _bomQuotationDocument = attachment;
          case 'drawing':
            _drawingDocument = attachment;
        }
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not select document: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeDocument(String kind) {
    setState(() {
      switch (kind) {
        case 'pi':
          _piDocument = null;
        case 'bom':
          _bomQuotationDocument = null;
        case 'drawing':
          _drawingDocument = null;
      }
    });
  }

  Future<void> _saveOrder() async {
    FocusScope.of(context).unfocus();
    if (_saving || !_formKey.currentState!.validate()) return;
    if (_stage == null || _wip == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select an active Stage and WIP value to continue.'),
        ),
      );
      return;
    }
    if (_loadingConfigurations || _configurationError != null) return;

    final profile = context.read<AuthProvider>().user;
    final authUser = Supabase.instance.client.auth.currentUser;
    if (profile == null ||
        authUser == null ||
        profile.id != authUser.id ||
        profile.tenantId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your signed-in account or workspace could not be verified.',
          ),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await _repository.submit(
        draft: OrderDraft(
          piNumber: _piNumber.text,
          stage: _stage!,
          wip: _wip!,
          orderDate: _orderDate.text,
          deliveryNeededOn: _nullableDate(_deliveryNeededOn.text),
          assemblyDate: _nullableDate(_assemblyDate.text),
          dispatchDate: _nullableDate(_dispatchDate.text),
          readyStock: _readyStock,
          companyName: _companyName.text,
          projectName: _projectName.text,
          projectTitle: _projectTitle.text,
          deliveryAddress: _deliveryAddress.text,
          clientName: _clientName.text,
          clientContactNumber: _clientContactNumber.text,
          customerEmailId: _customerEmailId.text,
          advanceReceived: OrderValidation.parseOptionalAmount(
            _advanceReceived.text,
          ),
          basicOrderValue: double.parse(_basicOrderValue.text.trim()),
          orderValueWithGst: double.parse(_orderValueWithGst.text.trim()),
        ),
        tenantId: profile.tenantId,
        userId: authUser.id,
        piDocument: _piDocument,
        bomQuotationDocument: _bomQuotationDocument,
        drawingDocument: _drawingDocument,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order saved successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save order: $error'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _nullableDate(String value) =>
      value.trim().isEmpty ? null : value.trim();

  @override
  Widget build(BuildContext context) {
    final generatedAt =
        DateFormat('dd MMM yyyy, h:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Order',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            _section(
              title: 'Order Information',
              icon: Icons.receipt_long_outlined,
              children: [
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Timestamp',
                    prefixIcon: Icon(Icons.schedule_outlined),
                    helperText: 'Generated automatically; cannot be edited',
                  ),
                  child: Semantics(
                    label: 'Timestamp generated automatically',
                    child: Text(generatedAt),
                  ),
                ),
                const SizedBox(height: 14),
                _textField(
                  controller: _piNumber,
                  label: 'PI Number',
                  icon: Icons.tag_outlined,
                  validator: (value) =>
                      OrderValidation.required(value, 'PI Number'),
                  textCapitalization: TextCapitalization.characters,
                ),
                _configurationDropdown(
                  label: 'Stage',
                  value: _stage,
                  options: _stages,
                  onChanged: (value) => setState(() => _stage = value),
                ),
                _configurationDropdown(
                  label: 'WIP',
                  value: _wip,
                  options: _wipOptions,
                  onChanged: (value) => setState(() => _wip = value),
                ),
                _dateField(
                  _orderDate,
                  'Order Date',
                  required: true,
                ),
              ],
            ),
            _section(
              title: 'Production & Delivery',
              icon: Icons.local_shipping_outlined,
              children: [
                _dateField(_deliveryNeededOn, 'Delivery Needed On'),
                _dateField(_assemblyDate, 'Assembly Date'),
                _dateField(_dispatchDate, 'Dispatch Date'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ready Stock'),
                  subtitle:
                      const Text('This order can be fulfilled from stock'),
                  value: _readyStock,
                  onChanged: (value) => setState(() => _readyStock = value),
                ),
              ],
            ),
            _section(
              title: 'Company / Project',
              icon: Icons.business_outlined,
              children: [
                _textField(
                  controller: _companyName,
                  label: 'Company Name',
                  icon: Icons.apartment_outlined,
                  validator: (value) =>
                      OrderValidation.required(value, 'Company Name'),
                  textCapitalization: TextCapitalization.words,
                ),
                _textField(
                  controller: _projectName,
                  label: 'Project Name',
                  icon: Icons.folder_outlined,
                  validator: (value) =>
                      OrderValidation.required(value, 'Project Name'),
                  textCapitalization: TextCapitalization.words,
                ),
                _textField(
                  controller: _projectTitle,
                  label: 'Project Title',
                  icon: Icons.title_outlined,
                  validator: (value) =>
                      OrderValidation.required(value, 'Project Title'),
                  textCapitalization: TextCapitalization.words,
                ),
                _textField(
                  controller: _deliveryAddress,
                  label: 'Delivery Address',
                  icon: Icons.location_on_outlined,
                  validator: (value) =>
                      OrderValidation.required(value, 'Delivery Address'),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                ),
              ],
            ),
            _section(
              title: 'Client Information',
              icon: Icons.person_outline,
              children: [
                _textField(
                  controller: _clientName,
                  label: 'Client Name',
                  icon: Icons.badge_outlined,
                  validator: (value) =>
                      OrderValidation.required(value, 'Client Name'),
                  textCapitalization: TextCapitalization.words,
                ),
                _textField(
                  controller: _clientContactNumber,
                  label: 'Client Contact Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) => OrderValidation.required(
                    value,
                    'Client Contact Number',
                  ),
                ),
                _textField(
                  controller: _customerEmailId,
                  label: 'Customer Email ID',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  validator: OrderValidation.email,
                ),
              ],
            ),
            _section(
              title: 'Financial Information',
              icon: Icons.payments_outlined,
              children: [
                _amountField(
                  _advanceReceived,
                  'Advance Received',
                  required: false,
                ),
                _amountField(
                  _basicOrderValue,
                  'Basic Order Value',
                  required: true,
                ),
                _amountField(
                  _orderValueWithGst,
                  'Order Value with GST',
                  required: true,
                ),
              ],
            ),
            _section(
              title: 'Attachments',
              icon: Icons.attach_file_outlined,
              children: [
                _attachmentPicker(
                  label: 'PI document',
                  kind: 'pi',
                  attachment: _piDocument,
                ),
                _attachmentPicker(
                  label: 'BOM/Quotation document',
                  kind: 'bom',
                  attachment: _bomQuotationDocument,
                ),
                _attachmentPicker(
                  label: 'Drawing document',
                  kind: 'drawing',
                  attachment: _drawingDocument,
                ),
              ],
            ),
            if (_configurationError != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Could not load Stage and WIP values.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(_configurationError!),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _loadingConfigurations
                              ? null
                              : _loadConfigurations,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_loadingConfigurations)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (!_loadingConfigurations &&
                _configurationError == null &&
                (_stages.isEmpty || _wipOptions.isEmpty))
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Active Stage and WIP values are required before this order can be saved.',
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ||
                        _loadingConfigurations ||
                        _configurationError != null ||
                        _stages.isEmpty ||
                        _wipOptions.isEmpty
                    ? null
                    : _saveOrder,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(
                  _saving ? 'Saving order...' : 'Save Order',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        textInputAction:
            maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }

  Widget _amountField(
    TextEditingController controller,
    String label, {
    required bool required,
  }) {
    return _textField(
      controller: controller,
      label: label,
      icon: Icons.currency_rupee,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) =>
          OrderValidation.amount(value, label, optional: !required),
    );
  }

  Widget _dateField(
    TextEditingController controller,
    String label, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: (value) => OrderValidation.date(
          value,
          label,
          optional: !required,
        ),
        onTap: () => _pickDate(controller),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          suffixIcon: IconButton(
            tooltip: 'Choose $label',
            onPressed: () => _pickDate(controller),
            icon: const Icon(Icons.edit_calendar_outlined),
          ),
        ),
      ),
    );
  }

  Widget _configurationDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        validator: (selected) => selected == null ? 'Select $label' : null,
        onChanged: _loadingConfigurations || options.isEmpty ? null : onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.tune_outlined),
        ),
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(option, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _attachmentPicker({
    required String label,
    required String kind,
    required OrderAttachment? attachment,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _saving ? null : () => _pickDocument(kind),
                icon: const Icon(Icons.upload_file_outlined),
                label: Text(attachment == null ? 'Choose file' : 'Change file'),
              ),
              if (attachment != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    attachment.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: 'Remove $label',
                  onPressed: _saving ? null : () => _removeDocument(kind),
                  icon: const Icon(Icons.close),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
